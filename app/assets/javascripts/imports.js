$(document).ready(function(){
  
  function poll_for_jobs(){

    if ($("#import_report").length){
      setTimeout(function(){
        
        //console.log ('Calling get status...');
  
        $(".import_report").each(function(){

          if ($(this).data("complete") === false){
            $.get('/import_status_job/'+$(this).data("id"), function (data) {
              
              if (data == ""){
                $("#import_report_"+data.id).text("No info to display... sorry something must have gone wrong here...");
              } else if (data.complete) {
                
                $("#import_report_"+data.id).text(data.summary);
                $("#import_log_"+data.id).text(data.log);
                $("#import_log_"+data.id).data("completed", "true");
                $("#import_report_"+data.id).removeClass("light-green");
                // end of recursive call
              }else{
                
                $("#import_report_"+data.id).addClass("light-green");
                // update div, and set up another poll again
                if (data.progress == 0) {
                  $("#import_report_"+data.id).text(data.name + " - Job not started yet");
                } else {
                  $("#import_report_"+data.id).text(data.name + " - ...loading : " + data.progress + " out of " + data.total);
                }
                // run another poll
                poll_for_jobs();
              }
            }, "json");
          }
        });
        
      },5000); 
    }
  }
  
  if ($("#import_report").length){
    poll_for_jobs();
  }
});