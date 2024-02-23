import { Controller } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails";
import { BrowserMultiFormatReader, NotFoundException } from "@zxing/library";
import SlimSelect from "slim-select";

// Connects to data-controller="scan-book"
export default class extends Controller {
  static targets = [
    "result",
    "sourceSelect",
    "sourceSelectPanel",
    "scannerComponent",
    "scannerActivate",
    "bookSelect",
  ];

  selectedDeviceId = null;
  codeReader = null;
  scannerPresent = false;
  scannerActive = false;
  barcodeInput = "";

  connect() {
    this.codeReader = new BrowserMultiFormatReader();

    this.initZxScanner();

    console.log("ZXing code reader initialized");

    this.activateBarcodeScanner();

    document.addEventListener("turbo:frame-missing", (event) => {
      if (event.detail.response.redirected) {
        event.preventDefault();
        event.detail.visit(event.detail.response);
      }
    });
  }

  activateBarcodeScanner() {
    console.log("Barcode scanner activated");
    document.addEventListener("keypress", this.handleBarcodeInput);
  }

  handleBarcodeInput = (event) => {
    console.log("Barcode input detected: ", event.key);
    if (event.key !== "Enter") {
      this.barcodeInput += event.key;
    } else {
      // 'Enter' key was pressed, indicating end of barcode input
      console.log("Scanned Barcode: ", this.barcodeInput);
      this.fetchBookMaster(this.barcodeInput); // Fetch book master using the barcode input
      this.barcodeInput = ""; // Reset for next scan
    }
  }

  initZxScanner() {
    this.codeReader
      .listVideoInputDevices()
      .then((videoInputDevices) => {
        this.selectedDeviceId = videoInputDevices[0].deviceId;
        if (videoInputDevices.length >= 1) {
          videoInputDevices.forEach((element) => {
            const sourceOption = document.createElement("option");
            sourceOption.text = element.label;
            sourceOption.value = element.deviceId;
            this.sourceSelectTarget.appendChild(sourceOption);
            if (this.sourceSelectTarget.slim) {
              this.sourceSelectTarget.slim.destroy();
            }
            this.sourceSelectTarget.slim = new SlimSelect({
              select: this.sourceSelectTarget,
              showSearch: false,
              allowDeselect: true,
              placeholder: true,
              settings: {
                closeOnSelect: false,
                placeholderText: this.sourceSelectTarget.dataset.placeholder,
              },
            });
          });

          this.sourceSelectTarget.addEventListener("change", () => {
            this.selectedDeviceId = this.sourceSelectTarget.value;
            this.resetScanner();
            this.startScanner();
          });

          this.sourceSelectPanelTarget.style.display = "block";

          this.scannerPresent = true;
        }
      })
      .catch((err) => {
        console.error(err);
      });
  }

  resetScanner() {
    if (!this.scannerPresent) {
      // alert("No scanner present");
      return;
    }
    this.codeReader.reset();
    document.getElementById("result").textContent = "";
    this.deactivateScanner();
  }

  startScanner() {
    if (!this.scannerPresent) {
      // alert("No scanner present");
      return;
    }
    this.codeReader.decodeFromVideoDevice(undefined, "video", (result, err) => {
      if (result) {
        console.log(result);
        document.getElementById("result").textContent = result.text;
        this.fetchBookMaster(result.text);
      }
      if (err && !(err instanceof NotFoundException)) {
        console.error(err);
        document.getElementById("result").textContent = err;
      }
    });
    console.log(
      `Started continuous decode from camera with id ${this.selectedDeviceId}`
    );
  }

  activateScanner() {
    if (!this.scannerPresent) {
      // alert("No scanner present");
      return;
    }
    this.scannerActive = true;
    this.scannerActivateTarget.style.display = "none";
    this.scannerComponentTarget.style.display = "block";
    this.startScanner();
  }

  deactivateScanner() {
    if (!this.scannerPresent) {
      // alert("No scanner present");
      return;
    }
    if (!this.scannerActive) {
      // alert("Scanner already inactive");
      return;
    }
    this.scannerActive = false;
    this.scannerActivateTarget.style.display = "block";
    this.scannerComponentTarget.style.display = "none";
  }

  fetchBookMaster(serial_number) {
    const url = `/api/v1/book_masters/${serial_number}`;

    fetch(url, {
      method: "GET",
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }
        return response.json();
      })
      .then((book_master) => {
        if (!book_master) {
          console.error("Book Master not found");
          alert("Book Master not found");
          return;
        }
        this.deactivateScanner();
        Turbo.visit(
          `/book_transactions/new?book_master_id=${book_master.book.id}`
        );
      })
      .catch((error) => {
        console.error("Error fetching Book Details:", error);
        alert("Error fetching Book Details: " + error);
      });
  }
}
