//= require active_admin/base
//= require activeadmin_addons/all
//= require chartkick
//= require Chart.bundle
 
$(document).ready(function() {
  // Start of the Dynamic forms for (Coats, Vests, Pants, Shirts)
  const itemTypeSelector = $('#item-type-selector');
 
  if (itemTypeSelector.length) {
    const coatsSection = $('#coats-section');
    const pantsSection = $('#pants-section');
    const vestsSection = $('#vests-section');
    const shirtsSection = $('#shirts-section');
 
    const toggleSections = (selectedType) => {
      coatsSection.hide();
      pantsSection.hide();
      vestsSection.hide();
      shirtsSection.hide();
 
      if (selectedType === 'Coats') {
        coatsSection.show();
      } else if (selectedType === 'Pants') {
        pantsSection.show();
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
 
  // Function to handle enabling/disabling fields based on "Rush Order"
  function handleRushOrder() {
    const isRushOrder = $('#rush-checkbox').is(':checked'); // Check if "Rush Order" is checked

    if (isRushOrder) {
      // Enable second and third fitting fields for manual input
      $('#second_fitting, #third_fitting').prop('disabled', false);
    } else {
      // For non-rush orders: disable fields but auto-calculate values
      $('#second_fitting, #third_fitting').prop('disabled', true);
      // Auto-calculate fitting dates based on first fitting
      populateFittingDates();
    }
  }

  // Function to auto-populate fitting dates
  function populateFittingDates() {
    const firstFittingDate = new Date($('#first_fitting').val());
    
    // Only proceed if first fitting date is valid
    if (!isNaN(firstFittingDate.getTime())) {
      // Calculate Second Fitting (first + 17 days)
      const secondFittingDate = new Date(firstFittingDate);
      secondFittingDate.setDate(firstFittingDate.getDate() + 17);
      $('#second_fitting').val(formatDate(secondFittingDate));
      
      // Calculate Third Fitting (second + 17 days)
      const thirdFittingDate = new Date(secondFittingDate);
      thirdFittingDate.setDate(secondFittingDate.getDate() + 17);
      $('#third_fitting').val(formatDate(thirdFittingDate));
    }
  }

  // Helper function to format date as YYYY-MM-DD
  function formatDate(date) {
    const year = date.getFullYear();
    const month = ('0' + (date.getMonth() + 1)).slice(-2);
    const day = ('0' + date.getDate()).slice(-2);
    return `${year}-${month}-${day}`;
  }

  $(document).ready(function() {
    // Event listeners
    $('#rush-checkbox').on('change', handleRushOrder);
    
    // For first fitting date changes
    $('#first_fitting').on('change', function() {
      // Only auto-calculate if not a rush order
      if (!$('#rush-checkbox').is(':checked')) {
        populateFittingDates();
      }
    });
    
    // Initial setup
    handleRushOrder(); // Ensure fields are correctly enabled/disabled on page load
  });

  $(".view-order-link").hover(function() {
    var orderId = $(this).data("order-id");
    $("#order-details-" + orderId).show();
  }, function() {
    $(".order-details").hide(); 
  });
  
});
