import { application } from "controllers/application"

import DynamicFormController from "controllers/dynamic_form_controller"
application.register("dynamic-form", DynamicFormController)

import MapController from "controllers/map_controller"
application.register("map", MapController)
