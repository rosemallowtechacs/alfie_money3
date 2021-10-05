package com.rosemallow.money3creditscore.VideoModule;


public class VideoData {

    String name;
    String album;
    String data;
    String duration;
    String date;
    String size;

    VideoData() {
    }

    public VideoData(String name, String album, String data, String duration, String size) {
        this.name = name;
        this.album = album;
        this.data = data;
        this.duration = duration;
        this.size = size;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAlbum() {
        return album;
    }

    public void setAlbum(String album) {
        this.album = album;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }


}
