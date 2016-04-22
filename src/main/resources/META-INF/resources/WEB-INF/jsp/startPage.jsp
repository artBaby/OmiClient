<%@ page import="java.util.*" %>
<%@ page import="netCrackerApp.objects.JsonHistory" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel='stylesheet' href='/css/main.css'/>
    <link rel='stylesheet' href='/css/panel.css'/>
    <link rel='stylesheet' href='/css/bootstrap.min.css'/>
    <link rel='stylesheet' href='/css/jquery-ui.css'/>
    <script src='${pageContext.request.contextPath}/javascript/Chart.js'></script>
    <script src="${pageContext.request.contextPath}/javascript/jquery-1.12.2.js"></script>
    <script src="${pageContext.request.contextPath}/javascript/jquery-ui.js"></script>
    <script src="${pageContext.request.contextPath}/javascript/jquery-ui.min.js"></script>
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
        <h1 style="text-align: center; font-style: normal;">Sentiment analisys</h1>
        <p style="text-align: center;">Here you can get sentiment analysis for each topic which you are interested in. Just fill the fields below.</p>
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
            <div id="sidebarBottom">
                <div class="panel panel-default">
                    <div class="panel-heading" style="padding:0 5px; font-family: Arial, Helvetica, sans-serif; background-color: #7D7777; border-color: #7D7777; color: white; font-weight: bold;">History</div>
                    <div id="history" class="panel-body">
                        <table class="table table-hover ">
                            <%
                                List<JsonHistory> listTopicsWithDates = (List<JsonHistory>) request.getAttribute("listTopicsWithDates");
                                for (JsonHistory history : listTopicsWithDates) {
                                    out.println("<tr><td><a style=\"text-decoration: none; color: black;\" href=\"#\" onclick=\"getTopicAndDateByLink(this); return false\">" +
                                            history.getTopic() + " - " + history.getCreatedDate() +"</a></td></tr>");
                                }
                            %>
                        </table>
                    </div>
                </div>
                <a href="#clearHistory" style="margin-top: -20px; float: right; color:#7f7f7f; font-size:14px;" onclick="deleteRequestHistory()">Clear history</a>
            </div>
        </div>
        <div id="main">
            <div id="inputFields">
                <form role="form" class="form-horizontal">
                    <div class="form-group">
                        <div class="col-sm-6"><label><span style="color: red;">*</span>Input your request</label><input type="text" class="form-control" id="requestText"></div>
                        <div class="col-sm-3"><label>From</label><input type="text" class="form-control" id="calendarFrom"></div>
                        <div class="col-sm-3"><label>To</label><input type="text" class="form-control" id="calendarTo"></div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-12">
                            <input type="button" class="btn btn-sample pull-right" value="get info!" onclick="getSentimentResultWithTweetsByTopic()" />
                        </div>
                    </div>
                    <fieldset class="form-group">
                        <div id="message" style="text-align: center; color: red;"></div>
                    </fieldset>
                </form>
            </div>
            <div id="output">
                <fieldset class="fieldset">
                    <ul class="nav nav-tabs" data-tabs="tabs">
                        <li class="active"><a id="tab1" href="#chart" data-toggle="tab">Chart</a></li>
                        <li><a id="tab2" href="#posts" data-toggle="tab">Posts</a></li>
                    </ul>
                    <div class="tab-content">
                        <div id="chart" class="tab-pane active">
                            <canvas id="barChart"></canvas>
                        </div>
                        <div id="posts" class="tab-pane"></div>
                    </div>
                </fieldset>
            </div>
        </div>
    </div>
    <div id="footer"> 2016 Opinion mining</div>
</div>

<script>
    var barChart;
    var macAddress = jQuery.parseJSON('${jsonMacAddress}');

    $(function(){
        $.datepicker.setDefaults(
                $.extend($.datepicker.regional["en"])
        );
        $("#calendarFrom").datepicker({dateFormat:'yy-mm-dd'});
        $("#calendarTo").datepicker({dateFormat:'yy-mm-dd'});
    });

    function getTopicAndDateByLink(value) {
        var topicAndDate = value.innerHTML;
        var activeTab = 'tab1';
        console.log('topicAndDate= ' + topicAndDate);
        $.ajax({
            url: '/getSentimentResultByTopicAndDate',
            type: 'POST',
            data: 'topicAndDate=' + topicAndDate + "&macAddress=" + macAddress,
            success: function (data) {
                console.log('data =  ' + data);
                var sentimentResultWithTweets = jQuery.parseJSON(data);
                var sentimentResults = sentimentResultWithTweets.map( sentimentResultTweet => sentimentResultTweet.sentimentResult);
                var numberOfTweets = sentimentResultWithTweets.map( sentimentResultTweet => sentimentResultTweet.numberOfTweets);
                $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                    activeTab = $(e.target).attr('id');
                    if (activeTab == 'tab1') {
                        if (barChart != undefined || barChart != null)
                            barChart.destroy();
                        drawChartBar(sentimentResults, numberOfTweets);
                    }
                });
                activeTab = $('.nav-tabs .active').text();
                if (activeTab == 'Chart'){
                    if (barChart != undefined || barChart != null)
                        barChart.destroy();
                    drawChartBar(sentimentResults, numberOfTweets);
                }
                showTweets(sentimentResultWithTweets);
            },
            error: function (data) {
                console.log('getTopicAndDateByLink Error =  ' + data);
                alert(data);
            }
        });

    }

    function drawChartBar(sentimentResultArray, numberOfTweetsArray) {

        //drawing Chart(Bar)
        var barChartData = {
            labels: sentimentResultArray,
            datasets: [
                {
                    fillColor: 'rgba(220,220,220,0.8)',
                    strokeColor: 'rgba(220,220,220,0.8)',
                    highlightFill: 'rgba(220,220,220,0.75)',
                    highlightStroke: 'rgba(220,220,220,1)',
                    data: numberOfTweetsArray
                }
            ]
        };

        var ctx = document.getElementById('barChart').getContext('2d');
        barChart = new Chart(ctx).Bar(barChartData, {
            responsive: true
        });
    }

    function showTweets(sentimentResultWithTweets) {
        var str= '<table class="table table-hover">';
        for(var k in sentimentResultWithTweets){
            var sentimentResultTweet = sentimentResultWithTweets[k];
            for(var i in sentimentResultTweet.tweets){
                str= str.concat('<tr><td>' + sentimentResultTweet.sentimentResult + '</td><td>' + sentimentResultTweet.tweets[i] + '</td></tr>');
            }
        }
        str.concat('</table>');
        $('#posts').html(str);

    }

    function getSentimentResultWithTweetsByTopic() {
        $('#message').empty();
        var inputText = $('#requestText').val().trim();
        var firstDate = $('#calendarFrom').val().trim();
        var lastDate = $('#calendarTo').val().trim();

        if(inputText === '') {
            $('#message').html('<h4 style="color: red">Enter data!</h4>');
            barChart.destroy();
            $('#posts').remove();
        }else {
            console.log('inputText= ' + inputText);
            console.log('firstDate= ' + firstDate);
            console.log('lastDate= ' + lastDate);
            $.ajax({
                url: '/ajaxRequest',
                type: 'POST',
                data: 'topic=' + inputText + "&firstDate=" + firstDate + "&lastDate=" + lastDate + "&macAddress=" + macAddress,
                success: function (data) {
                    console.log('data=' + data);
                    getHistory();
                    var sentimentResultWithTweets = jQuery.parseJSON(data);
                    var sentimentResults = sentimentResultWithTweets.map( sentimentResultTweet => sentimentResultTweet.sentimentResult);
                    var numberOfTweets = sentimentResultWithTweets.map( sentimentResultTweet => sentimentResultTweet.numberOfTweets);
                    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                        activeTab = $(e.target).attr('id');
                        if (activeTab == 'tab1') {
                            if (barChart != undefined || barChart != null)
                                barChart.destroy();
                            drawChartBar(sentimentResults, numberOfTweets);
                        }
                    });
                    activeTab = $('.nav-tabs .active').text();
                    if (activeTab == 'Chart'){
                        if (barChart != undefined || barChart != null)
                            barChart.destroy();
                        drawChartBar(sentimentResults, numberOfTweets);
                    }
                    showTweets(sentimentResultWithTweets);
                },
                error: function (data) {
                    console.log('error =  ' + data);
                    alert(data);
                }
            });
        }
    }

    function getHistory() {
        console.log('ip= ' + macAddress);
        $.ajax({
            url: '/ajaxGetHistory',
            type: 'POST',
            data: 'macAddress=' + macAddress,
            success: function (data) {
                var listTopicsWithDates = jQuery.parseJSON(data);

                var str= '<table class="table table-hover">';
                for(var i in listTopicsWithDates){
                    var topicWithDate = listTopicsWithDates[i];
                        str= str.concat('<tr><td><a style="text-decoration: none; color: black;" href="#" onclick="getTopicAndDateByLink(this); return false">' + topicWithDate.topic + ' - ' + topicWithDate.createdDate + '</a></td></tr>');
                }
                str.concat('</table>');
                $('#history').html(str);

            },
            error: function (data) {
                console.log('getHistory Error =  ' + data);
                alert(data);
            }
        });
    }

    function deleteRequestHistory() {
        console.log('ip= ' + macAddress);
        $.ajax({
            url: '/delete',
            type: 'POST',
            data: 'macAddress=' + macAddress,
            success: function (data) {
                $('#history').html('<table class="table table-hover"></table>');
            },
            error: function (data) {
                console.log('deleteRequestHistory Error =  ' + data);
                alert(data);
            }
        });

    }
</script>
</body>
</html>