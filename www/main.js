// Start NProgress when starting calculations
$(document).on('shiny:busy', function(event) {
    NProgress.start({
      showSpinner: false,
    });
});

// End NProgress when shiny goes idle 
$(document).on('shiny:idle', function(event) {
    NProgress.done();
});