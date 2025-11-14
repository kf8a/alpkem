// Import and register all your controllers from the import map under controllers/*

import { application } from "controllers/application"

// Manually import and register controllers
import FileUploadController from "controllers/file_upload_controller"
application.register("file-upload", FileUploadController)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
