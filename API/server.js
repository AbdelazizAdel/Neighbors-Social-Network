var express = require('express'); // Web Framework
var bodyParser = require("body-parser");
var app = express();
var sql = require("mssql"); // MS Sql Server client

// Connection string parameters.
// var sqlConfig = {
//     connectionString: 'Driver=SQL Server;Server=localhost\\SQLEXPRESS;Database=master;Trusted_Connection=true;'

// };
var sqlConfig = {
user: 'sa',
password: 'Password123',
server: 'localhost',
database: 'master',
pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000
  }
} 

let connection = sql.connect(sqlConfig,err => {
  if (err)
   {throw err}
})

// sql.connect(config, function (err) {
    
//     if (err) console.log("5555");

  
// });


app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Start server and listen on http://localhost:8081/
var server = app.listen(8081, function() {
    var host = server.address().address
    var port = server.address().port

    console.log("app listening at http://%s:%s", host, port)
});

app.put("/event/:eventID/:username", (req, res) => {
    const username = req.params.username;
    const eventId = req.params.eventID;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input("username", username).input("eventID", eventId);
        request.execute(
            "accept_event_invitation",
            (err, recordsets, returnedValue, affected) => {
                if (err) console.log(err);
                res.end(JSON.stringify(recordsets)); // Result in JSON format
            }
        );
    });
});



app.put("/friend_request/:senderUN/:recieverUN", (req, res) => {
    const senderUN = req.params.senderUN;
    const recieverUN = req.params.recieverUN;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input("senderUN", senderUN);
        request.input("receiverUN", recieverUN);
        request.execute(
            "accept_request",
            (err, recordsets, returnedValue, affected) => {
                if (err) console.log(err);
                res.end(JSON.stringify(recordsets)); // Result in JSON format
            }
        );
    });
});

app.post("/create_group", (req, res) => {
    const username = req.body.username;
    const groupName = req.body.groupName;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input("username", username);
        request.input("groupName", groupName);
        request.execute(
            "CREATE_GROUP",
            (err, recordsets, returnedValue, affected) => {
                if (err) console.log(err);
                res.end(JSON.stringify(recordsets)); // Result in JSON format
            }
        );
    });
});

app.get("/view_friends/:UN", (req, res) => {
    const username = req.params.UN;
    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input("memberUN", username);
        request.execute(
            "view_my_friends",
            (err, recordsets, returnedValue, affected) => {
                if (err) console.log(err);
                res.end(JSON.stringify(recordsets)); // Result in JSON format
            }
        );
    });
});

app.put('/accepts_group_request/:groupID/:username', (req, res) => {
    const groupID = req.params.groupID;
    const username = req.params.username;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input("groupID", groupID).input("username", username);
        request.execute(
            "accepts_group_request",
            (err, recordsets, returnedValue, affected) => {
                if (err) console.log(err);
                res.end(JSON.stringify(recordsets)); // Result in JSON format
            }
        );
    });
});


app.post("/add_to_group", (req, res) => {
    const memberUN = req.body.memberusername;
    const adminUN = req.body.adminusername;
    const groupname = req.body.groupname;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('memberusername', memberUN);
        request.input('adminusername', adminUN);
        request.input('groupname', groupname);
        request.execute('add_to_group', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.post('/block_Member', (req, res) => {
    const blocker_username = req.body.blocker_username;
    const blocked_username = req.body.blocked_username;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('blocker_username', blocker_username);
        request.input('blocked_username', blocked_username);
        request.execute('block_Member', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.post('/BuyItem', (req, res) => {
    const itemID = req.body.itemID;
    const username = req.body.username;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('itemID', itemID);
        request.input('username', username);
        request.execute('BuyItem', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.put('/change_a_given_rating', (req, res) => {
    const raterUN = req.body.raterUN;
    const ratedUN = req.body.ratedUN;
    const rating = req.body.rating;
    const rating_content = req.body.rating_content;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('raterUN', raterUN);
        request.input('ratedUN', ratedUN);
        request.input('rating', rating);
        request.input('rating_content', rating_content);
        request.execute('change_a_given_rating', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.post('/change_password', (req, res) => {
    const username = req.body.username;
    const old_password = req.body.old_password;
    const new_password = req.body.new_password;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('username', username);
        request.input('old_password', old_password);
        request.input('new_password', new_password);
        request.output('success', sql.Bit);
        request.execute('change_password', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.post('/comment_on_post', (req, res) => {
    const username = req.body.username;
    const content = req.body.content;
    const newsID = req.body.newsID;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('username', username);
        request.input('content', content);
        request.input('newsID', newsID);
        request.execute('comment_on_post', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.put('/edit_post', (req, res) => {
    const username = req.body.username;
    const content = req.body.content;
    const postID = req.body.postID;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('username', username);
        request.input('content', content);
        request.input('postID', postID);
        request.execute('edit_post', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.get('/FindAvailableServices/:start_time/:end_time', (req, res) => {
    const start_time = req.params.start_time;
    const end_time = req.params.end_time;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('start_time', start_time);
        request.input('end_time', end_time);
        request.execute('FindAvailableServices', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.post('/group_join_request', (req, res) => {
    const groupName = req.body.groupName;
    const memberUN = req.body.memberUN;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('groupName', groupName);
        request.input('memberUN', memberUN);
        request.execute('group_join_request', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.post('/invite_member_to_event', (req, res) => {
    const organizerUN = req.body.organizerUN;
    const attendeeUN = req.body.attendeeUN;
    const eventID = req.body.eventID;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('organizerUN', organizerUN);
        request.input('attendeeUN', attendeeUN);
        request.input('eventID', eventID);
        request.execute('invite_member_to_event', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });

});

app.post('/MAKE_ADMIN', (req, res) => {
    const adminusername = req.body.adminusername;
    const memberusername = req.body.memberusername;
    const groupname = req.body.groupname;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('adminusername', adminusername);
        request.input('memberusername', memberusername);
        request.input('groupname', groupname);
        request.execute('MAKE_ADMIN', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.delete('/Leave_Group', (req, res) => {
    const username = req.body.username;
    const groupname = req.body.groupname;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('username', username);
        request.input('groupname', groupname);
        request.execute('Leave_Group', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});


app.delete('/delete_event_admin', (req, res) => {
    const id = req.body.id;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('id', id);
        request.execute('delete_event_admin', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.delete('/DELETE_GROUP', (req, res) => {
    const groupID = req.body.groupID;
    const username = req.body.username;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('groupID', groupID);
        request.input('username', username);
        request.execute('DELETE_GROUP', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.delete('/delete_group_admin', (req, res) => {
    const id = req.body.id;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('id', id);
        request.execute('delete_group_admin', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.delete('/delete_house_admin', (req, res) => {
    const house_num = req.body.house_num;
    const st_name = req.body.st_name;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('house_num', house_num);
        request.input('st_name', st_name);
        request.execute('delete_house_admin', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.delete('/delete_item', (req, res) => {
    const itemid = req.body.itemid;
    const username = req.body.username;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('itemid', itemid);
        request.input('username', username);
        request.execute('delete_item', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.delete('/delete_item_admin', (req, res) => {
    const id = req.body.id;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('id', id);
        request.execute('delete_item_admin', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.delete('/delete_member_admin', (req, res) => {
    const username = req.body.username;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('username', username);
        request.execute('delete_member_admin', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.delete('/delete_news_admin', (req, res) => {
    const id = req.body.id;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('id', id);
        request.execute('delete_news_admin', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.delete('/delete_post', (req, res) => {
    const username = req.body.username;
    const postID = req.body.postID;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('username', username);
        request.input('postID', postID);
        request.execute('delete_post', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.delete('/delete_service', (req, res) => {
    const serviceId = req.body.serviceId;
    const username = req.body.username;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('serviceId', serviceId);
        request.input('username', username);
        request.execute('delete_service', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.delete('/delete_service_admin', (req, res) => {
    const id = req.body.id;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('id', id);
        request.execute('delete_service_admin', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.post('/write_post', (req, res) => {
    const username = req.body.username;
    const content = req.body.content;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('username', username);
        request.input('content', content);
        request.execute('write_post', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.get('/viewHouse/:username', (req, res) => {
    const username = req.params.username;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('username', username);
        request.execute('viewHouse', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.get('/view_posts/:username', (req, res) => {
    const username = req.params.username;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('username', username);
        request.execute('view_posts', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.get('/view_news_with_keywords/:username/:keywords', (req, res) => {
    const username = req.params.username;
    const keywords = req.params.keywords;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('username', username);
        request.input('keywords', keywords);
        request.execute('view_news_with_keywords', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.get('/view_my_rating/:memberUN', (req, res) => {
    const memberUN = req.params.memberUN;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('memberUN', memberUN);
        request.execute('view_my_rating', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.get('/view_my_friends/:memberUN', (req, res) => {
    const memberUN = req.params.memberUN;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('memberUN', memberUN);
        request.execute('view_my_friends', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.get('/view_members/:memberUN', (req, res) => {
    const memberUN = req.params.memberUN;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('memberUN', memberUN);
        request.execute('view_members', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets.recordset)); // Result in JSON format
        });
    });
});

app.get('/view_chat/:senderUN/:receiverUN', (req, res) => {
    const senderUN = req.params.senderUN;
    const receiverUN = req.params.receiverUN;

    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('senderUN', senderUN);
        request.input('receiverUN', receiverUN);
        request.execute('view_chat', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.get('/VIEW_ITEM/:username', (req, res) => {
    const username = req.params.username;
    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input('username', username);
        request.execute('VIEWITEM', (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        })
    })
})

app.post("/offer_item", (req, res) => { // working as required
    const username = req.body.username;
    const itemName = req.body.itemName;
    const price = req.body.price;
    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input("username", username);
        request.input("itemName", itemName);
        request.input("price", price);
        request.execute("offeritem", (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});
app.post("/offer_Service", (req, res) => { //working as required
    const username = req.body.username;
    const serviceName = req.body.serviceName;
    const price = req.body.price;
    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input("username", username);
        request.input("serviceName", serviceName);
        request.input("price", price);
        request.execute("offerService", (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    });
});

app.post("/organize_event", (req, res) => { // working as required
    const creatorUN = req.body.creatorUN;
    const eventName = req.body.eventName;
    const eventDate = req.body.eventDate;
    const privacy = req.body.privacy;
    const type = req.body.type;
    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input("creatorUN", creatorUN);
        request.input("eventName", eventName);
        request.input("eventDate", eventDate);
        request.input("privacy", privacy);
        request.input("type", type);
        request.execute("organize_event", (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        });
    })
});

app.post("/rate_member", (req, res) => { //working as required
    const raterUN = req.body.raterUN;
    const ratedUN = req.body.ratedUN;
    const rating = req.body.rating;
    const rating_content = req.body.rating_content;
    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input("raterUN", raterUN);
        request.input("ratedUN", ratedUN);
        request.input("rating", rating);
        request.input("rating_content", rating_content);
        request.execute("rate_member", (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        })
    })
})

app.post("/register_User", (req, res) => { //working as required
    const username = req.body.username;
    const name = req.body.name;
    const neighborhood = req.body.neighborhood;
    const password = req.body.password;
    const street_name = req.body.street_name;
    const house_number = req.body.house_number;
    const postal_code = req.body.postal_code;
    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input("username", username);
        request.input("name", name);
        request.input("neighborhood", neighborhood);
        request.input("password", password);
        request.input("street_name", street_name);
        request.input("house_number", house_number);
        request.input("postal_code", postal_code);
        request.output("success", sql.Bit);
        request.execute("registerUser", (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        })

    })
})

app.put("/reject_event_invitation", (req, res) => { //working as required
    const username = req.body.username;
    const eventID = req.body.eventID;
    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input("username", username);
        request.input("eventID", eventID);
        request.execute("reject_event_invitation", (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        })
    })
})

app.put("/reject_request", (req, res) => { //working as required
    const senderUN = req.body.senderUN;
    const receiverUN = req.body.receiverUN;
    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input("senderUN", senderUN);
        request.input("receiverUN", receiverUN);
        request.execute("reject_request", (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        })
    })
})

app.put("/rejects_group_request", (req, res) => { // working as required
    const groupName = req.body.groupName;
    const username = req.body.username;
    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input("groupName", groupName);
        request.input("username", username);
        request.execute("rejects_group_request", (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        })
    })
})

app.delete("/Remove_From_Group", (req, res) => { //works as required
    const memberusername = req.body.memberusername;
    const adminusername = req.body.adminusername;
    const groupname = req.body.groupname;
    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input("memberusername", memberusername);
        request.input("adminusername", adminusername);
        request.input("groupname", groupname);
        request.execute("Remove_From_Group", (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        })
    })
});

app.post("/report_member", (req, res) => { // working as required
    const reporterUN = req.body.reporterUN;
    const reportedUN = req.body.reportedUN;
    const content = req.body.content;
    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input("reporterUN", reporterUN);
        request.input("reportedUN", reportedUN);
        request.input("content", content);
        request.execute("report_member", (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        })
    })
})

app.post("/send_message", (req, res) => { // working as required
    const senderUN = req.body.senderUN;
    const receiverUN = req.body.receiverUN;
    const content = req.body.content;
    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input("senderUN", senderUN);
        request.input("receiverUN", receiverUN);
        request.input("content", content);
        request.execute("send_message", (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        })
    })
})

app.post("/send_request", (req, res) => { // working as required
    const senderUN = req.body.senderUN;
    const receiverUN = req.body.receiverUN;
    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.output("success_bit", sql.Bit);
        request.input("senderUN", senderUN);
        request.input("receiverUN", receiverUN);
        request.execute("send_request", (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        })
    })
})

app.delete("/Unblock", (req, res) => { //working as required
    const blockedusername = req.body.blockedusername;
    const blockerusername = req.body.blockerusername;
    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input("blockedusername", blockedusername);
        request.input("blockerusername", blockerusername);
        request.execute("Unblock", (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        })
    })
})

app.post("/user_login", (req, res) => { // works  as required
    const username = req.body.username;
    const password = req.body.password;
    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.output("success", sql.Bit);
        request.input("username", username);
        request.input("password", password);
        request.execute("user_login", (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        })
    })
})

app.post("/use_This_Service", (req, res) => { // working as required
    const serviceID = req.body.serviceID;
    const username = req.body.username;
    const start_time = req.body.start_time;
    const end_time = req.body.end_time;
    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.output("success", sql.Bit);
        request.input("serviceID", serviceID);
        request.input("username", username);
        request.input("start_time", start_time);
        request.input("end_time", end_time);
        request.execute("useThisService", (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        })

    })

})

app.get("/view_blocked/:username", (req, res) => { //working as required
    const username = req.params.username;
    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.input("username", username);
        request.execute("view_blocked", (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        })
    })
})

app.get("/view_comments/:newsID", (req, res) => {
    const newsID = req.params.newsID
    sql.connect(sqlConfig, () => {
        var request = new sql.Request()
        request.input("newsID", newsID);
        request.execute("view_comments", (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        })
    })
})

app.get('/view_member_details/:UN', (req, res) => {
  const username = req.params.UN;
  sql.connect(sqlConfig, () => {
    var request = new sql.Request();
    request.input('username', username);
    request.execute('view_member_details', (err, recordsets, returnedValue, affected) => {
      if (err) console.log(err);
      res.end(JSON.stringify(recordsets.recordset)); // Result in JSON format
    });
  });
});


app.get("/view_all_members", (req, res) => {
    sql.connect(sqlConfig, () => {
        var request = new sql.Request();
        request.execute("view_all_members", (err, recordsets, returnedValue, affected) => {
            if (err) console.log(err);
            res.end(JSON.stringify(recordsets)); // Result in JSON format
        })
    })
})



app.get("view_messages/:memID" , (req, res) => {

	const memID = req.params.memID 
	  sql.connect(sqlConfig, () => {
    var request = new sql.Request();
    request.input('username', memID);
    request.execute('view_messages', (err, recordsets, returnedValue, affected) => {
      if (err) console.log(err);
      res.end(JSON.stringify(recordsets.recordset)); // Result in JSON format
    });
  });




})