package netCrackerApp.Dao;

import com.mongodb.BasicDBObject;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import netCrackerApp.objects.JsonHistory;
import netCrackerApp.objects.JsonSentimentResult;
import org.bson.Document;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class History {
    private final MongoDao mongoDao = MongoDao.getInstance();
    private final MongoCollection<Document> history = mongoDao.db.getCollection("history");
    SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy.MM.dd 'at' HH:mm:ss.SSS");


    public void saveHistoryOfRequest(String ipAddress, String topic, List<JsonSentimentResult> ListJsonSentimentResultWithTweets){
        System.out.println("saveHistoryOfRequestToDB");

        List<Document> listDocuments = new ArrayList<>();
        for (JsonSentimentResult jsonSentimentResultWithTweets : ListJsonSentimentResultWithTweets) {
            Document doc = new Document();
            doc.append("sentimentResult", jsonSentimentResultWithTweets.getSentimentResult())
            .append("numberOfTweets", jsonSentimentResultWithTweets.getNumberOfTweets())
            .append("tweets", jsonSentimentResultWithTweets.getTweets());
            listDocuments.add(doc);
        }

        Document document = new Document();
        document.append("ipAddress", ipAddress)
                        .append("topic", topic)
                        .append("createdAt", new Date())
                        .append("createdDateMillisec", new Date().getTime())
                        .append("sentimentResultWithTweets", listDocuments);
        history.insertOne(document);
    }

    public List<JsonHistory> getTopicsAndDates(String ipAddress) {
        List<JsonHistory> listTopicsWithDate = new ArrayList<>();
        BasicDBObject basicDBObject = new BasicDBObject();
        basicDBObject.put("ipAddress",ipAddress);
        FindIterable<Document> documents = history.find(basicDBObject).sort(new BasicDBObject("createdAt",-1));
        for (Document document : documents) {
            String topic = (String) document.get("topic");
            Long createdDate = (Long) document.get("createdDateMillisec");
            listTopicsWithDate.add(new JsonHistory(simpleDateFormat.format(createdDate),topic));
        }
        return listTopicsWithDate;
    }

    public void deleteHistory (String ipAddress){
        BasicDBObject basicDBObject = new BasicDBObject();
        basicDBObject.put("ipAddress",ipAddress);
        System.out.println("DELTEEEEEEEEEEEEEEEEEEEEEEE");
        history.deleteMany(basicDBObject);
    }

    public List<JsonSentimentResult> getSentimentResultByTopicAndDate (String ipAddress, String topic, Long date) {
        List<JsonSentimentResult> sentimentResultsWithTweets = new ArrayList<>();
        BasicDBObject basicDBObject = new BasicDBObject();
        basicDBObject.put("ipAddress",ipAddress);
        basicDBObject.put("topic",topic);
        basicDBObject.put("createdDateMillisec", date);
        FindIterable<Document> documents = history.find(basicDBObject);
        for (Document document : documents) {
            List<Document> listSentimentResultWithTweets = (List<Document>) document.get("sentimentResultWithTweets");
            for (Document sentimentResultWithTweets : listSentimentResultWithTweets) {
                System.out.println(sentimentResultWithTweets);
                String sentimentResult = (String) sentimentResultWithTweets.get("sentimentResult");
                Long numberOfTweets = (Long) sentimentResultWithTweets.get("numberOfTweets");
                List<String> tweets = (List<String>) sentimentResultWithTweets.get("tweets");
                System.out.println("tweets = " + tweets);
                sentimentResultsWithTweets.add(new JsonSentimentResult(sentimentResult, numberOfTweets, tweets));
            }
        }
        return sentimentResultsWithTweets;
    }

}

