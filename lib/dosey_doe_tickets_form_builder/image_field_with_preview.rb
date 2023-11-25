module DoseyDoeTicketsFormBuilder
  module ImageFieldWithPreview
    def image_field_with_preview(method, options = {})
      @template.content_tag(:div,
                            class: "mt-2 flex justify-center rounded-lg border border-dashed border-gray-900/25 px-6 py-10",
                            data: {
                              controller: "file-drop preview",
                              action: "dragover->file-drop#dragover dragleave->file-drop#dragleave drop->file-drop#drop"
                            }) do

        @template.content_tag(:div, class: "text-center") do
          preview_image = if object.send(method).attached? && object.persisted?
                            @template.image_tag object.send(method), class: "w-auto max-h-48 object-cover mx-auto rounded-lg", data: { preview_target: "output" }
                          else
                            ""
                          end

          placeholder_svg = @template.content_tag(:svg, class: "#{"hidden" if object.send(method).attached? } mx-auto h-12 w-12 text-gray-300", viewBox: "0 0 24 24", fill: "currentColor", "aria-hidden": "true", data: { preview_target: "placeholder", turbo_permanent: "" }) do
            @template.content_tag(:path, "", "fill-rule": "evenodd", d: "M1.5 6a2.25 2.25 0 012.25-2.25h16.5A2.25 2.25 0 0122.5 6v12a2.25 2.25 0 01-2.25 2.25H3.75A2.25 2.25 0 011.5 18V6zM3 16.06V18c0 .414.336.75.75.75h16.5A.75.75 0 0021 18v-1.94l-2.69-2.689a1.5 1.5 0 00-2.12 0l-.88.879.97.97a.75.75 0 11-1.06 1.06l-5.16-5.159a1.5 1.5 0 00-2.12 0L3 16.061zm10.125-7.81a1.125 1.125 0 112.25 0 1.125 1.125 0 01-2.25 0z", "clip-rule": "evenodd")
          end

          image_preview = @template.tag(:img, src: "#", id: "image-preview", alt: "Uploaded Image Preview", class: "mx-auto hidden max-h-48 w-auto rounded-lg object-cover", data: { preview_target: "output", turbo_permanent: "" })

          upload_section = @template.content_tag(:div, class: "mt-4 flex justify-center text-sm leading-6 text-gray-600") do
            label = label(method, class: "relative cursor-pointer rounded-md bg-white font-semibold text-indigo-600 focus-within:outline-none focus-within:ring-2 focus-within:ring-indigo-600 focus-within:ring-offset-2 hover:text-indigo-500", data: { image_preview_target: "input" }) do
              @template.safe_join [
                                    @template.content_tag(:span, "Upload a file"),
                                    file_field(method, class: "sr-only", data: { file_drop_target: "input", action: "change->preview#preview", turbo_permanent: true }),
                                    error_message_for(method)
                                  ]
            end
            @template.safe_join [label, @template.content_tag(:p, "or drag and drop", class: "pl-1")]
          end

          @template.safe_join([preview_image, image_preview, placeholder_svg, upload_section])
        end
      end
    end
  end
end