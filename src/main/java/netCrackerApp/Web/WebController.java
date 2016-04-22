
package netCrackerApp.Web;

import netCrackerApp.Dao.History;
import netCrackerApp.Dao.MongoDao;
import netCrackerApp.SentimentAnalysis;
import netCrackerApp.objects.JsonHistory;
import netCrackerApp.objects.JsonSentimentResult;
import netCrackerApp.objects.SentimentTweet;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;


@Controller
public class WebController {
    private final MongoDao mongoDao = MongoDao.getInstance();
    private final SentimentAnalysis sentimentAnalysis = new SentimentAnalysis();
    private History history = new History();
    @Autowired
    private JavaMailSender javaMailSender;


    @RequestMapping("/")
    public String index(HttpServletRequest request, Model model) {
        String ipAddress  = request.getRemoteAddr(); //get client Ip Address
        List<JsonHistory> listTopicsWithDates = history.getTopicsAndDates(ipAddress);

        ObjectMapper mapper = new ObjectMapper();
        String jsonIpAddress = "";
        try {
            jsonIpAddress = mapper.writeValueAsString(ipAddress);
        } catch (IOException e) {
            e.printStackTrace();
        }

        model.addAttribute("jsonIpAddress", jsonIpAddress);
        model.addAttribute("listTopicsWithDates", listTopicsWithDates);
        return "startPage";
    }

    @RequestMapping(value = "/ajaxRequest", method = RequestMethod.POST)
    public @ResponseBody String getSentimentResultByTopic(@RequestParam("topic") String topic,
                                                          @RequestParam("firstDate") String firstDate,
                                                          @RequestParam("lastDate") String lastDate,
                                                          @RequestParam("ipAddress") String ipAddress) throws Exception {

        System.out.println("this is from controller: " + topic + "  " +firstDate + "  " + lastDate);
        List<JsonSentimentResult> jsonSentimentResultWithTweets = new ArrayList<>();
        List<SentimentTweet> tweetsFromDB = mongoDao.getTweets(topic,firstDate,lastDate);
        Map<Integer, Long> sentimentResultOnTopic = sentimentAnalysis.getSentimentResultByTopic(tweetsFromDB);

        //Code below and method "update value" are workaround for right order of topics
        jsonSentimentResultWithTweets.add(new JsonSentimentResult("Negative", (long)0, null));
        jsonSentimentResultWithTweets.add(new JsonSentimentResult("Somewhat negative", (long)0, null));
        jsonSentimentResultWithTweets.add(new JsonSentimentResult("Neutral", (long)0, null));
        jsonSentimentResultWithTweets.add(new JsonSentimentResult("Somewhat positive", (long)0, null));
        jsonSentimentResultWithTweets.add(new JsonSentimentResult("Positive", (long)0, null));

        for (Integer sentimentResult : sentimentResultOnTopic.keySet()) {
            List<String> tweets = tweetsFromDB.stream().filter(sentimentTweet -> sentimentTweet.getSentimentResult() == sentimentResult).distinct().limit(2).map(sentimentTweet -> sentimentTweet.getTextPost()).collect(Collectors.toList());
            if(sentimentResult.equals(0)) jsonSentimentResultWithTweets.set(0, updateValue("Negative", sentimentResultOnTopic.get(sentimentResult), tweets));
            if(sentimentResult.equals(1)) jsonSentimentResultWithTweets.set(1, updateValue("Somewhat negative", sentimentResultOnTopic.get(sentimentResult), tweets));
            if(sentimentResult.equals(2)) jsonSentimentResultWithTweets.set(2, updateValue("Neutral", sentimentResultOnTopic.get(sentimentResult), tweets));
            if(sentimentResult.equals(3)) jsonSentimentResultWithTweets.set(3, updateValue("Somewhat positive", sentimentResultOnTopic.get(sentimentResult), tweets));
            if(sentimentResult.equals(4)) jsonSentimentResultWithTweets.set(4, updateValue("Positive", sentimentResultOnTopic.get(sentimentResult), tweets));
        }

        ObjectMapper mapper = new ObjectMapper();
        String json = "";
        try {
            json = mapper.writeValueAsString(jsonSentimentResultWithTweets);
        } catch (IOException e) {
            e.printStackTrace();
        }
        history.saveHistoryOfRequest(ipAddress, topic, jsonSentimentResultWithTweets);  //save history of the request to MongoDB collection 'history'

        return json;
    }

    private JsonSentimentResult updateValue(String sentimentResult, long numberOfTweets, List<String> tweets){
        return (new JsonSentimentResult(sentimentResult,numberOfTweets, tweets ));
    }

    @RequestMapping(value = "/ajaxGetHistory", method = RequestMethod.POST)
    public @ResponseBody String getHistory(@RequestParam("ipAddress") String ipAddress){
        List<JsonHistory> listTopicsWithDate = history.getTopicsAndDates(ipAddress);

        ObjectMapper mapper = new ObjectMapper();
        String jsonListTopicsWithDate = "";
        try {
            jsonListTopicsWithDate = mapper.writeValueAsString(listTopicsWithDate);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return jsonListTopicsWithDate;
    }

    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    public @ResponseBody String deleteRequestHistory(@RequestParam("ipAddress") String ipAddress){
        history.deleteHistory(ipAddress);
        String str = "";
        return str;
    }

    @RequestMapping(value = "/getSentimentResultByTopicAndDate", method = RequestMethod.POST)
    public @ResponseBody String getSentimentResultFromHistory(@RequestParam("topicAndDate") String topicAndDate, @RequestParam("ipAddress") String ipAddress){
        String[] strings = topicAndDate.split("-");
        String topic = strings[0].trim();
        Long date = 0L;
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy.MM.dd 'at' HH:mm:ss.SSS");
        try {
            date = simpleDateFormat.parse(strings[1].trim()).getTime();
        } catch (ParseException e) {
            e.printStackTrace();
        }

        List<JsonSentimentResult> sentimentResultWithTweets = history.getSentimentResultByTopicAndDate(ipAddress, topic, date);

        ObjectMapper mapper = new ObjectMapper();
        String jsonSentimentResultWithTweets = "";
        try {
            jsonSentimentResultWithTweets = mapper.writeValueAsString(sentimentResultWithTweets);
        } catch (IOException e) {
            e.printStackTrace();
        }

        return jsonSentimentResultWithTweets;
    }

    @RequestMapping(value = "/help")
    public ModelAndView help() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("help");
        return mav;
    }

    @RequestMapping(value = "/info")
    public ModelAndView info() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("information");
        return mav;
    }

    @RequestMapping(value = "/sendEmail", method = RequestMethod.POST)
    public @ResponseBody String sendEmail(HttpServletRequest request,
                                          HttpServletResponse response,
                                          @RequestParam("email") String emailUser,
                                          @RequestParam("subject") String subject,
                                          @RequestParam("content") String content) throws MessagingException{
        String email = "omi.sentiment@yandex.ru";

        Pattern pattern = Pattern.compile("^([a-z0-9_\\.-]+)@([a-z0-9_\\.-]+)\\.([a-z\\.]{2,6})$", Pattern.CASE_INSENSITIVE);
        Matcher matcher = pattern.matcher(emailUser);
        System.out.println(matcher.matches());
        if(!matcher.matches()){
           return "Your email address is invalid. Please enter a valid address.";
        }
        if(content.trim().isEmpty()){
            return "Please enter the content.";
        }

        JavaMailSenderImpl sender = new JavaMailSenderImpl();
        MimeMessage message = sender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message);
        helper.setTo(email);
        helper.setFrom(email);
        helper.setSubject(subject);
        helper.setText("<p>Email user:  "+emailUser+"</p><p>" + content + "</p>", true);
        javaMailSender.send(message);
        return "The message has been sent!";
    }

}
