import express, { Express, Request, Response } from 'express';
import { reviewmodel } from '../model/review';
import { Usermodel } from '../model/users';

class ReviewDomain {

    //POST Review
    async postReview(req: Request, res: Response) {
        var nextID: any = await reviewmodel.findOne({}, { _id: 1 }).sort({ _id: -1 });
        var reqData: any = JSON.parse(JSON.stringify(req.headers['data']));
        var uid: String = reqData.uid;

        var postData: object = {
            _id: nextID?._id == undefined ? 1 : Number(nextID?.id) + 1,
            user_id: uid,
            hotel_id: req.params.id,
            date: Date.now(),
            comment: req.body.comment,
            cleanliness: req.body.cleanliness,
            comfort: req.body.comfort,
            location: req.body.location,
            facilities: req.body.facilities,
        }

        var data = new reviewmodel(postData);
        try {
            await data.save();
            res.send("data added ");
        }
        catch (err: any) {
            res.send(err.message);
        }
        res.end();

    }

    // Get Hotel Review
    async getHotelReview(req: Request, res: Response) {
        var hotelReview = await reviewmodel.find({ hotel_id: req.params.id }).populate({ path: 'user_id', model: Usermodel, select: { 'user_name': 1, '_id': 0 } });
        res.send(hotelReview);
        res.end();
    }

}

//EXPORT
export { ReviewDomain };