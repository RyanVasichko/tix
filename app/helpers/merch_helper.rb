module MerchHelper
  def classes_for_all_merch_chip
    base_classes = "rounded-3xl border mr-2 py-1.5 px-3 text-xs font-medium uppercase sm:flex-1 cursor-pointer focus:outline-none"
    base_classes + if all_selected?
                     "border-transparent bg-amber-600 text-white hover:bg-amber-700"
                   else
                     "border-gray-200 bg-white text-gray-900 hover:bg-gray-50"
                   end
  end
end
