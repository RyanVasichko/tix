import { StreamActions } from "@hotwired/turbo"
import Idiomorph from "idiomorph"

StreamActions.morph = function() {
  Idiomorph.morph(this.targetElements[0], this.templateContent);
}