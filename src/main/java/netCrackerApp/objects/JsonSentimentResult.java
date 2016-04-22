package netCrackerApp.objects;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

public class JsonSentimentResult {
    private List<String> tweets;
    private String sentimentResult;
    private Long numberOfTweets;

    @JsonCreator
    public JsonSentimentResult(@JsonProperty("sentimentResult") String sentimentResult, @JsonProperty("numberOfTweets") Long numberOfTweets, @JsonProperty("tweets") List<String> tweets) {
        this.sentimentResult = sentimentResult;
        this.numberOfTweets = numberOfTweets;
        this.tweets = tweets;
    }

    public List<String> getTweets() {
        return tweets;
    }

    public void setTweets(List<String> tweets) {
        this.tweets = tweets;
    }

    public String getSentimentResult() {
        return sentimentResult;
    }

    public void setSentimentResult(String sentimentResult) {
        this.sentimentResult = sentimentResult;
    }

    public Long getNumberOfTweets() {
        return numberOfTweets;
    }

    public void setNumberOfTweets(Long numberOfTweets) {
        this.numberOfTweets = numberOfTweets;
    }
}
