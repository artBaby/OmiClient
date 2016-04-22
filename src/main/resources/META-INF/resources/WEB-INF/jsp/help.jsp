<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel='stylesheet' href='/css/main.css'/>
    <link rel='stylesheet' href='/css/bootstrap.min.css'/>
    <link rel='stylesheet' href='/css/jquery-ui.css'/>
    <script src="${pageContext.request.contextPath}/javascript/jquery-1.12.2.js"></script>
    <script src="${pageContext.request.contextPath}/javascript/jquery-ui.js"></script>
    <script src="${pageContext.request.contextPath}/javascript/bootstrap.min.js"></script>
</head>
<body>
<div id="wrapper">
    <div id="header">
        <a href="/"><img src="../images/squirrel.png"  width="68" height="85" hspace="15"></a>
        <h4 style="color: orangered; padding: 25px 0 0 0; display: inline-block;">Opinion Mining</h4>
        <ul>
            <li><a href="info">Information</a></li>
            <li><a href="help">Help</a></li>
        </ul>
    </div>
    <div id="description">
        <h2 style="text-align: center;">Send Message to Administrator</h2>
        <p>All fields marked with an asterisk (<span style="color: red;">*</span>) are required. Fill out the fields below and then choose "Submit" to send your message to the Administrator.</p>
    </div>
    <div id="content">
        <div id="sidebar">
            <div id="sidebarTop">
                <!-- start feedwind code -->
                <script type="text/javascript">
                    document.write('\x3Cscript type="text/javascript" src="' + ('https:' == document.location.protocol ? 'https://' : 'http://') + 'feed.mikle.com/js/rssmikle.js">\x3C/script>');
                </script>
                <script type="text/javascript">
                    (function() {
                        var params = {
                            rssmikle_url: "https://news.google.com/news?pz=1&cf=all&ned=us&hl=en&output=rss",
                            rssmikle_frame_width: "300",
                            rssmikle_frame_height: "400",
                            frame_height_by_article: "2",
                            rssmikle_target: "_blank",
                            rssmikle_font: "Arial, Helvetica, sans-serif",
                            rssmikle_font_size: "14",
                            rssmikle_border: "on",
                            responsive: "on",
                            rssmikle_css_url: "",
                            text_align: "left",
                            text_align2: "left",
                            corner: "on",
                            scrollbar: "on",
                            autoscroll: "on",
                            scrolldirection: "up",
                            scrollstep: "2",
                            mcspeed: "20",
                            sort: "New",
                            rssmikle_title: "on",
                            rssmikle_title_sentence: "News from around the World",
                            rssmikle_title_link: "",
                            rssmikle_title_bgcolor: "#7D7777",
                            rssmikle_title_color: "#FFFFFF",
                            rssmikle_title_bgimage: "",
                            rssmikle_item_bgcolor: "#FFFFFF",
                            rssmikle_item_bgimage: "",
                            rssmikle_item_title_length: "55",
                            rssmikle_item_title_color: "#595959",
                            rssmikle_item_border_bottom: "on",
                            rssmikle_item_description: "on",
                            item_link: "off",
                            rssmikle_item_description_length: "180",
                            rssmikle_item_description_color: "#666666",
                            rssmikle_item_date: "gl1",
                            rssmikle_timezone: "Etc/GMT",datetime_format: "%b %e, %Y %k:%M",
                            item_description_style: "text+tn",
                            item_thumbnail: "full",
                            item_thumbnail_selection: "auto",
                            article_num: "15",
                            rssmikle_item_podcast: "off",
                            keyword_inc: "",
                            keyword_exc: ""
                        };
                        feedwind_show_widget_iframe(params);})();
                </script>
                <div style="font-size:12px; text-align:right; ">
                    <a href="http://feed.mikle.com/" target="_blank" style="color:#7f7f7f;">RSS Feed Widget</a>
                    <!--Please display the above link in your web page according to Terms of Service.-->
                </div>
                <!-- end feedwind code -->
            </div>
        </div>
        <div id="main">
              <form>
                 <fieldset class="form-group">
                    <label for="email"><span style="color: red;">*</span>Email address</label>
                    <input type="email" class="form-control" id="email" placeholder="Enter email">
                 </fieldset>
                  <fieldset class="form-group">
                    <label for="subject">Subject</label>
                     <input type="email" class="form-control" id="subject" placeholder="Enter subject">
                 </fieldset>
                  <fieldset class="form-group">
                      <label for="textArea"><span style="color: red;">*</span>Content</label>
                      <textarea class="form-control" id="textArea" rows="3"></textarea>
                  </fieldset>
                  <button type="button" class="btn btn-sample" onclick="sendEmail()">Submit</button>
                  <fieldset class="form-group">
                          <div id="message" style="text-align: center; color: #3b94d9;"></div>
                  </fieldset>
              </form>
        </div>
    </div>
    <div id="footer"> 2016 Opinion mining</div>
</div>

<script>



    function sendEmail() {
       $('#message').empty();
       var email = $('#email').val();
       var subject = $('#subject').val();
       var content = $('#textArea').val();
        $.ajax({
            url: '/sendEmail',
            type: 'POST',
            data: 'email=' + email + "&subject=" + subject + "&content=" + content,
            success: function (data) {
                console.log('data=' + data);
                $('#message').html('<h3>' + data + '</h3>');
            },
            error: function (data) {
                console.log('error =  ' + data);
                alert(data);
            }
        });
    }
</script>

</body>
</html>
