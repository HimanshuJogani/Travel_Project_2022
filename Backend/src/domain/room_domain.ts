import { hotelmodel } from '../model/hotel';
import express, { Express, Request, Response } from 'express';
import { imagemodel } from '../model/image'
import {StatusCode} from '../statuscode'


class RoomDomain {

    // commen function 
    async getRoomWithType(req: Request, res: Response , roomtype : String) {
        var hotelid: Number = Number(req.params.id);

        try {
            var data: any = await hotelmodel.findOne({ _id: hotelid }, { _id: 1, hotel_name: 1, room: 1 });
            var roomdata: any = await data?.room.find((o: any) => String(o.room_type) === roomtype);
            var imagedata: object | null = await imagemodel.find({ $and: [{ room_id: roomdata?.room_id }, { hotel_id: hotelid }] });
            if (data == null) {
                res.status(StatusCode.Not_Found).send("can't find hotel on this id");
            }
            else {
                if (roomdata == null)
                {
                    roomdata = [];
                    imagedata = [];
                }
                var responseJson: object = {
                    hotel_id: data._id,
                    hotel_name: data?.hotel_name,
                    room_data: roomdata,
                    room_image: imagedata
                }

                res.status(StatusCode.Sucess).send(responseJson);
            }

        }

        catch (err: any) {
            res.status(StatusCode.Server_Error).send(err.message);
        }

    }


   // Get Room with Deluxe Type 
    async getRoomWithDeluxeType(req: Request, res: Response) {
        await this.getRoomWithType(req, res , "Deluxe");
    }

    // Get Room with Semi-Deluxe Type 
    async getRoomWithSemiDeluxeType(req: Request, res: Response) {
      await this.getRoomWithType(req, res , "Semi-Deluxe");

    }

     // Get Room with Super-Deluxe Type 
     async getRoomWithSuperDeluxeType(req: Request, res: Response) {
       await this.getRoomWithType(req, res , "Super-Deluxe")

     }
}

//EXPORT
export { RoomDomain };