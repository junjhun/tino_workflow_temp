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
        $secondFittingInput.prop('readonly', true).attr('placeholder', 'N/A').val('').addClass('readonly-style');
        $secondFittingMessage.show();

        $thirdFittingInput.prop('readonly', true).attr('placeholder', 'N/A').val('').addClass('readonly-style');
        $thirdFittingMessage.show();

        $fourthFittingInput.prop('readonly', true).attr('placeholder', 'N/A').val('').addClass('readonly-style');
        $fourthFittingMessage.show();
      } else {
        $secondFittingInput.prop('readonly', false).attr('placeholder', '').removeClass('readonly-style');
        $secondFittingMessage.hide();

        $thirdFittingInput.prop('readonly', false).attr('placeholder', '').removeClass('readonly-style');
        $thirdFittingMessage.hide();

        $fourthFittingInput.prop('readonly', false).attr('placeholder', '').removeClass('readonly-style');
        $fourthFittingMessage.hide();
      }
      handleRushOrder();
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
      $('#second_fitting, #third_fitting').prop('readonly', false).removeClass('readonly-style');
    } else {
      // For non-rush orders: disable fields but auto-calculate values
      $('#second_fitting, #third_fitting').prop('readonly', true).addClass('readonly-style');
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

  // --- Monogram Fields Logic ---
  // Function to handle monogram field states
  function handleMonogramFields(initialsInput) {
    const $initialsInput = $(initialsInput);
    const $parentContainer = $initialsInput.closest('.inputs.has_many_fields');
    const $placementSelect = $parentContainer.find('select.monogram-placement-input');
    const $fontSelect = $parentContainer.find('select.monogram-font-input');

    // Get the trimmed, lowercase value of the initials input
    const initialsValue = $initialsInput.val().trim().toLowerCase();

    if (initialsValue === '' || initialsValue === 'none' || initialsValue === 'n/a') {
      // Monogram initials are blank | None | N/A
      $placementSelect.prop('disabled', true).addClass('readonly-style').val('').trigger('change');
      $fontSelect.prop('disabled', true).addClass('readonly-style').val('').trigger('change');
    } else {
      // Monogram initials have a value
      $placementSelect.prop('disabled', false).removeClass('readonly-style');
      $fontSelect.prop('disabled', false).removeClass('readonly-style');
    }
  }

  // Event delegation for monogram initials inputs
  // Apply to both coats and shirts sections when their specific initials field changes
  $('#coats-section, #shirts-section').on('change', 'input.monogram-initials-input', function() {
    handleMonogramFields(this);
  });

  // Ensure initial state on page load for existing records
  // This needs to run for each existing coat/shirt on load
  $('#coats-section input.monogram-initials-input').each(function() {
    handleMonogramFields(this);
  });
  $('#shirts-section input.monogram-initials-input').each(function() {
    handleMonogramFields(this);
  });

  // --- Start of Shirt Collar Style Logic ---
  // This function is now designed to be called for both existing and new forms.
  function handleShirtCollarOptions(shirtFormContainer) {
    const $collarStyleSelect = $(shirtFormContainer).find('select.collar-style-select');
    const $traditionalCollarOptionsWrapper = $(shirtFormContainer).find('.traditional-collar-options-wrapper');
    const $traditionalCollarRadios = $traditionalCollarOptionsWrapper.find('input[type="radio"]');

    function toggleTraditionalCollarOptions() {
      if ($collarStyleSelect.val() === 'Traditional') {
        $traditionalCollarOptionsWrapper.show();
      } else {
        $traditionalCollarOptionsWrapper.hide();
        // Clear selection when hiding to prevent incorrect data submission
        $traditionalCollarRadios.prop('checked', false);
      }
    }

    // Call on load/initialization
    toggleTraditionalCollarOptions();

    // Attach event listener
    $collarStyleSelect.on('change', toggleTraditionalCollarOptions);
  }
  // --- End of Shirt Collar Style Logic ---

  // Active Admin appends new forms within the .has_many_container
  $('.has_many_container').on('has_many_add', function(event, fieldset) {
    setTimeout(() => {
      // Monogram initialization for new forms
      $(fieldset).find('input.monogram-initials-input').each(function() {
        handleMonogramFields(this);
      });
      // Collar initialization for new forms
      handleShirtCollarOptions(fieldset);
    }, 50);
  });

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


  $(document).ready(function() {
    // This function can be reused for coats, shirts, pants, etc.
    function initializeItemSwitcher(itemType) {
      var switcher = $('#' + itemType + '-switcher');
      var contentPanels = $('.' + itemType + '-content');

      // If there's no switcher on the page for this item, do nothing.
      if (switcher.length === 0) {
        return;
      }

      // When the page loads, hide all content panels except the first one.
      contentPanels.not(':first').hide();

      // When the dropdown value changes...
      switcher.on('change', function() {
        var selectedIndex = $(this).val();
        // Hide all content panels.
        contentPanels.hide();
        // Show only the panel that matches the selected index.
        $('#' + itemType + '-content-' + selectedIndex).show();
      });
    }

    // Initialize the switcher for coats.
    initializeItemSwitcher('coat');
    initializeItemSwitcher('shirt');
    initializeItemSwitcher('pant');
    initializeItemSwitcher('vest');
  });

});
