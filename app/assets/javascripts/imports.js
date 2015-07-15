$(document).ready(function(){
  var loadingStr = " loading ...";
  
  function poll_for_import_status(){
    if ($("#import_report").length){
      setTimeout(function(){
        doUpdateImportStatus();
      },5000); 
    }
  }
  
  if ($("#import_report").length){
    doUpdateImportStatus();
    poll_for_import_status();  // this starts polling for first time if we are on import_status page. 
  }

  function doUpdateImportStatus(){
    $(".import_report").each(function(){

      if ($(this).data("complete") === false){
        $.get('/import_status_job/'+$(this).data("id"), function (data) {
          
          if (data == ""){
            $("#import_report_"+data.id).text("No info to display... sorry something must have gone wrong here...");
          
            
          } else if (data.run) {
            $("#import_report_"+data.id).text(data.summary);
            $("#import_log_"+data.id).html("<p>" + data.log + "</p>");
            $("#import_log_"+data.id).data("completed", "true");
            $("#import_report_"+data.id).removeClass("amber");
            $("#import_report_"+data.id).removeClass("lime");
            $("#import_report_"+data.id).addClass("light-green");
            $("#run_live_btn").hide();
            // end of recursive call                
          } else if (data.complete) {
            $("#run_live_btn").show(); 
            $("#import_report_"+data.id).text(data.summary + "  -  PENDING");
            $("#import_log_"+data.id).html("<p>" + data.log + "</p>");
            $("#import_log_"+data.id).data("completed", "true");
            $("#import_report_"+data.id).removeClass("amber");
            $("#import_report_"+data.id).addClass("lime");
            // end of recursive call
          }else{
            $("#run_live_btn").hide();
            // update div, and set up another poll again
            if (data.progress == 0) {
              $("#import_report_"+data.id).text(data.summary + " - Job not started yet");
            } else {
              loadingStr = loadingStr + ".";
              $("#import_report_"+data.id).text(data.name + " - " + data.progress + " out of " + data.total + loadingStr);
            }
            // run another poll
            poll_for_import_status();
          }
        }, "json");
      }
    });  
  }
});

$(document).on('click', '.importBtn', function() {
  $(".loading").show();  //show spinner if uploading a file. 
});

