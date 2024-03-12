import { Turbo } from "@hotwired/turbo-rails"
import { Idiomorph } from "idiomorph"

Turbo.StreamActions.morph = function() {
  Idiomorph.morph(this.targetElements[0], this.templateContent);
}
