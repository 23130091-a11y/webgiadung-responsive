package com.webgiadung.webgiadung.dao;

import com.webgiadung.webgiadung.model.Slide;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class SlideDao extends BaseDao{
    public static List<Slide> getListSlide(){
        Jdbi jdbi= get();

        List<Slide> slides=
                jdbi.withHandle(h->{
                    return h.createQuery("select * from slides where status = 1").mapToBean(Slide.class).list();
                });

        return slides;
    }

    public static Slide getById(int id) {
        return get().withHandle(h -> {
            return h.createQuery("SELECT * FROM slides WHERE id = :id")
                    .bind("id", id)
                    .mapToBean(Slide.class)
                    .findOne()
                    .orElse(null);
        });
    }

    public static List<Slide> getAllSlides() {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM slides ORDER BY id DESC")
                        .mapToBean(Slide.class)
                        .list()
        );
    }

    public static int insert(Slide slide) {
        return get().withHandle(handle -> {
            return handle.createUpdate(
                            "INSERT INTO slides (title, banner, description, status, created_at, updated_at) " +
                                    "VALUES (:title, :banner, :description, :status, NOW(), NOW())"
                    )
                    .bindBean(slide)
                    .execute();
        });
    }

}
