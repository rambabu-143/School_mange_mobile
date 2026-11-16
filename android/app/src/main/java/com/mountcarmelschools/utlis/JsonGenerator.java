package com.mountcarmelschools.utlis;

import com.mountcarmelschools.di.data.staff.markAttandance.MarkAttendanceResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class JsonGenerator {


    public static JSONObject getJson(String standard_section_id,
                                     String standard_id,
                                     String date,
                                     ArrayList<MarkAttendanceResponse.Data> list) throws JSONException {

        JSONObject mainJson = new JSONObject();

        mainJson.put(
                "standard_section_id",
                standard_section_id
        );
        mainJson.put(
                "standard_id",
                standard_id
        );
        mainJson.put("date", date);


        JSONArray jsonArray = new JSONArray();

        for (int i = 0; i < list.size(); i++) {

            JSONObject json = new JSONObject();
            json.put("student_id", list.get(i).getId());
            if (list.get(i).getFirst().equalsIgnoreCase("first") &&
                    list.get(i).getSecond().equalsIgnoreCase("seconf")) {
                json.put("type", "full");
                json.put("value", 1);

            } else if (list.get(i).getFirst().equalsIgnoreCase("first")) {
                json.put("type", "first");
                json.put("value", 0.5);

            } else {
                json.put("type", "second");
                json.put("value", 0.5);

            }

            json.put("reason", list.get(i).getReason());
            json.put("details", "");
            json.put("information", list.get(i).getInformation());

            jsonArray.put(json);
        }
// Adding json array as an element of json object
        mainJson.put("students", jsonArray);

        return mainJson;
    }
}
