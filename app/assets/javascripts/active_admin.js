//= require active_admin/base
//= require activeadmin_addons/all
//= require chartkick
//= require Chart.bundle
 
$(document).ready(function() {
  // Start of the Dynamic forms for (Coats, Vests, Pants/Skirts, Shirts)
  const itemTypeSelector = $('#item-type-selector');
 
  if (itemTypeSelector.length) {
    const coatsSection = $('#coats-section');
    const pantsSkirtSection = $('#pants-skirt-section');
    const vestsSection = $('#vests-section');
    const shirtsSection = $('#shirts-section');
 
    const toggleSections = (selectedType) => {
      coatsSection.hide();
      pantsSkirtSection.hide();
      vestsSection.hide();
      shirtsSection.hide();
 
      if (selectedType === 'Coats') {
        coatsSection.show();
      } else if (selectedType === 'Pants/Skirt') {
        pantsSkirtSection.show();
      } else if (selectedType === 'Vests') {
        vestsSection.show();
      } else if (selectedType === 'Shirts') {
        shirtsSection.show();
      }
    };
 
    toggleSections(itemTypeSelector.val());
 
    itemTypeSelector.on('change', function() {
      toggleSections($(this).val());
    });
  }
 
  // Start of the Fields for brand name that must be hidden.
  // Handling brand name select and fittings
  const $brandNameSelect = $('#type_of_brand');
  const $secondFittingInput = $('#second_fitting');
  const $thirdFittingInput = $('#third_fitting');
  const $fourthFittingInput = $('#fourth_fitting');
 
  if ($brandNameSelect.length && $secondFittingInput.length && $thirdFittingInput.length && $fourthFittingInput.length) {
    // Create indicator messages
    const $secondFittingMessage = $('<span>')
      .text('Second fitting is not applicable for St. James.')
      .css('color', 'red')
      .hide();
    $secondFittingInput.parent().append($secondFittingMessage);
 
    const $thirdFittingMessage = $('<span>')
      .text('Third fitting is not applicable for St. James.')
      .css('color', 'red')
      .hide();
    $thirdFittingInput.parent().append($thirdFittingMessage);
 
    const $fourthFittingMessage = $('<span>')
      .text('Fourth fitting is not applicable for St. James.')
      .css('color', 'red')
      .hide();
    $fourthFittingInput.parent().append($fourthFittingMessage);
 
    function updateFittings() {
      if ($brandNameSelect.val() === 'St. James') {
        $secondFittingInput.prop('disabled', true).attr('placeholder', 'N/A').val('');
        $secondFittingMessage.show();
     
        $thirdFittingInput.prop('disabled', true).attr('placeholder', 'N/A').val('');
        $thirdFittingMessage.show();
 
        $fourthFittingInput.prop('disabled', true).attr('placeholder', 'N/A').val('');
        $fourthFittingMessage.show();
      } else {
        $secondFittingInput.prop('disabled', false).attr('placeholder', '');
        $secondFittingMessage.hide();
 
        $thirdFittingInput.prop('disabled', false).attr('placeholder', '');
        $thirdFittingMessage.hide();
 
        $fourthFittingInput.prop('disabled', false).attr('placeholder', '');
        $fourthFittingMessage.hide();
      }
    }
 
    updateFittings();
 
    const intervalId = setInterval(() => {
      if (document.readyState === 'complete') {
        updateFittings();
      }
    }, 500);
 
    $brandNameSelect.change(updateFittings);
    $(window).on('beforeunload', function() {
      clearInterval(intervalId);
    });
  }
 
  // New Auto-Population Logic for Fittings
  function populateFittingDates() {
    const firstFittingDate = new Date($('#first_fitting').val());
    const secondFittingDate = new Date($('#second_fitting').val());
    const thirdFittingDate = new Date($('#third_fitting').val());
 
    // If First Fitting is provided, calculate Second, Third, and Fourth fitting dates
    if (!isNaN(firstFittingDate.getTime())) {
      const secondFittingDate = new Date(firstFittingDate);
      secondFittingDate.setDate(firstFittingDate.getDate() + 17); // Add 17 days (2.5 weeks)
      $('#second_fitting').val(formatDate(secondFittingDate));
 
      const thirdFittingDate = new Date(secondFittingDate);
      thirdFittingDate.setDate(secondFittingDate.getDate() + 17); // Add 17 days (2.5 weeks)
      $('#third_fitting').val(formatDate(thirdFittingDate));
 
      const fourthFittingDate = new Date(thirdFittingDate);
      fourthFittingDate.setDate(thirdFittingDate.getDate() + 17); // Add 17 days (2.5 weeks)
      $('#fourth_fitting').val(formatDate(fourthFittingDate));
 
    // If Second Fitting is provided and First Fitting is ignored
    } else if (!isNaN(secondFittingDate.getTime())) {
      const thirdFittingDate = new Date(secondFittingDate);
      thirdFittingDate.setDate(secondFittingDate.getDate() + 17); // Add 17 days (2.5 weeks)
      $('#third_fitting').val(formatDate(thirdFittingDate));
 
      const fourthFittingDate = new Date(thirdFittingDate);
      fourthFittingDate.setDate(thirdFittingDate.getDate() + 17); // Add 17 days (2.5 weeks)
      $('#fourth_fitting').val(formatDate(fourthFittingDate));
 
    // If Third Fitting is provided and First and Second Fittings are ignored
    } else if (!isNaN(thirdFittingDate.getTime())) {
      const fourthFittingDate = new Date(thirdFittingDate);
      fourthFittingDate.setDate(thirdFittingDate.getDate() + 17); // Add 17 days (2.5 weeks)
      $('#fourth_fitting').val(formatDate(fourthFittingDate));
    }
  }
 
  // Listen for changes on the fitting fields
  $('#first_fitting, #second_fitting, #third_fitting').change(populateFittingDates);
 
  // Helper function to format date as YYYY-MM-DD
  function formatDate(date) {
    const year = date.getFullYear();
    const month = ('0' + (date.getMonth() + 1)).slice(-2);
    const day = ('0' + date.getDate()).slice(-2);
    return `${year}-${month}-${day}`;
  }
});
