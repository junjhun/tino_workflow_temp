document.addEventListener('DOMContentLoaded', function() {
    var heardFromSource = document.getElementById('heard_from_source');
    var heardFromSourceOther = document.getElementById('heard_from_source_other');
  
    if (heardFromSource && heardFromSourceOther) {
      heardFromSource.addEventListener('change', function() {
        if (heardFromSource.value === 'Others') {
          heardFromSourceOther.style.display = 'block';
        } else {
          heardFromSourceOther.style.display = 'none';
        }
      });
  
      // Trigger change event to set initial state
      heardFromSource.dispatchEvent(new Event('change'));
    }
  });