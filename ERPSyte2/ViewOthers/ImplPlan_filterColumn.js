(function (window, undefined) {
  "use strict";

  var wordlist = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November',
        'December', 'Yammer', 'Yaw', 'Yawn', 'Auspiscious',
        'Arbitrage', 'Arbiter', 'Arbor', 'Ardor', 'Ardent',
        'Concrete', 'Conscious', 'Uptight', 'Uplevel', 'Friend',
        'Depend', 'Deepend', 'Deepen', 'Decommit', 'Right', 'Now',
        'Knowledge', 'Knight', 'Know', 'Knickers', 'Wow', 'Holy',
        'Velocity', 'Rational', 'Quiet', 'Quick', 'Quite', 'Quotient',
        'Wait', "Wither", "Whither", "Indignant", 'Jingle', 'Bells',
        'Snow', 'Sled', 'Dinner', 'Open', 'Fancy', 'Farsighted',
        'Farther', 'Giant', 'Ginormous', 'Giggle', 'License',
        'Follow', 'Foil', 'Foe', 'Swing', 'Sweater', 'Sweetheart',
        'Terrarium', 'Corn', 'Coal', 'Colocate', 'Coil', 'Likeness',
        'Jail', 'Chill', 'Last', 'Holiday', 'House', 'Chip', 'Grain',
        'Grand', 'Creek', 'Crumple', 'Crash', 'Crunch', 'Challenge',
        'Patience', 'Wisdom', 'Creak', 'Point', 'Warmth',
        'Imaginative', 'Imagine', 'Imaginative', 'Smokes', 'Calumny',
        'Call', 'California', 'Can', 'Cat', 'Petition', 'Pelt',
        'Random', 'Delicious', 'Cartwheel', 'Venetian', 'Lake',
        'Work', 'Music', 'Trumpet', 'Arbitrary', 'Distance',
        'Geography', 'Wrapper', 'Wren', 'Wrestle', 'Trestle', 'Treat',
        'Trick', 'Trip', 'Trying', 'Opine', 'Father', 'Fallacious',
        'Fallacy', 'Falling', 'Rain', 'Blue', 'Safe', 'Utility',
        'Carpet', 'Imitate', 'Immigrant', 'Immigrate', 'Grate',
        'Great', 'Snip', 'Sniff', 'Snoot', 'Swat', 'Hoot', 'Gig',
        'Angel', 'Angina', 'Chocolate', 'Chick', 'Check', 'Chock',
        'Chaff', 'Delist', 'Delightful', 'Delete', 'Jam', 'Debt',
        'Set', 'Sex', 'Serrated', 'Realistic', 'Relative', 'Redo',
        'Renege', 'Real', 'Regret', 'Tip', 'Tick', 'Tin',
        'Tickle', 'Rip', 'Ride', 'Cull', 'Culinary',
        'Caulk', 'Knee', 'Potato', 'Potential', 'Pore', 'Poor', 'Pie',
        'Pickle', 'Piquant', 'Puppy', 'Pump', 'Putrid', 'Power',
        'Punt', 'Peck', 'Pester', 'Pert', 'Few', 'Febrile',
        'Fickle', 'Fin', 'Fine', 'Fit', 'Baby', 'Barista',
        'Bark', 'Bail', 'Backboard', 'Basil', 'Hello', 'Helium',
        'Heckle', 'Hence', 'Low', 'Love', 'Long', 'Locked', 'Woe',
        'Wombat', 'Worsted', 'Pants', 'Paint', 'Patent', 'Palpable',
        'Conical', 'Tongue', 'Tarriff', 'Tax', 'Tange',
        'Tahoma', 'Curve', 'Curt', 'Ceiling', 'Conundrum', 'Coffee',
        'Haberdasher', 'Teamwork', 'Eritrea', 'Erudition', 'Titanium',
        'Prepare', 'Predisposed', 'Pretend', 'Twang', 'Tweak',
        'Polite', 'Dahlia', 'Dancing', 'Daft', 'Rope', 'Rodent',
        'Luck', 'Luke', 'Rutabaga', 'Ruckus', 'Rubber', 'Woot', 'Frank',
        'Aspire', 'Asinine', 'Aspersion', 'Attire', 'Attentive',
        'Attract', 'Fracture', 'Whammy', 'Whether', 'Wick', 'Sophomoric',
        'Socialist', 'Sonorous', 'Sound', 'Snarl', 'Street', 'Strict',
        'Stammer', 'Stick', 'Stay', 'Stumped', 'Stew', 'Shut', 'Ship',
        'Shush', 'Shapely', 'Shudder', 'Shambles', 'Sample', 'Samuel',
        'Same', 'Trust', 'Grapple', 'Grin', 'Ski', 'Skip', 'Scuttle',
        'Scrape', 'Skiff', 'Scamper', 'Science', 'Silence', 'Silo',
        'Silt', 'Silky', 'Smooth', 'Smother', 'Special', 'Sputter',
        'Split', 'Spline', 'Spin', 'Smile', 'Stiff', 'Stack', 'Stuck',
        'Torque', 'Tone', 'Ton', 'Tornado', 'Hurricane', 'Hurry',
        'Helpful', 'Weigh', 'Went', 'Weather', 'Wet', 'Sophia',
        'Write', 'Wrought', 'Gift', 'Lick', 'List', 'Fraud', 'Viper',
        'Vine', 'Vindicated', 'Voice', 'Vouch', 'Pound', 'Pouch',
        'Through', 'Thickness', 'Thought', 'Thorough', 'Thrift',
        'Though', 'Thanks', 'Thud', 'Tanks', 'Tingle', 'Tiny',
        'Tents', 'Affirmed', 'Afterwards', 'Affair', 'Affront',
        'Front', 'Back', 'Ballast', 'Frame', 'Tug', 'Tussle',
        'Torrent', 'Together', 'Switch', 'Wedge', 'Rent', 'Insipid',
        'Inside', 'Indoors', 'Infinite', 'Indecent', 'Decent',
        'Into', 'Enter', 'Ensure', 'Insure', 'Endowed', 'Enthralled',
        'Encourage', 'Cuff', 'Whiz', 'Wizard', 'Bullet', 'Bulwark',
        'Bull', 'Billet', 'Blame', 'Blimp', 'Boil', 'Boneyard',
        'Ballistic', 'Bonsai', 'Rote', 'Hone', 'Dote', 'Door',
        'Dorothy', 'Donor', 'Dry', 'Drip', 'Drain', 'Dross',
        'Cross', 'Crisp', 'Drafty', 'Pull', 'Deny', 'Donate',
        'Drift', 'Dip', 'Educate', 'Editor', 'Elucidate', 'Elapsed',
        'Erase', 'Erode', 'Cede', 'Cetacean', 'Frigid', 'Pleasure',
        'Plow', 'Plumb', 'Jump', 'Julian', 'Joke', 'Jocular',
        'Jovian', 'Jordan', 'River', 'Arrest', 'Arrive', 'Riven'
  ];


  wordlist.sort();


  function monkeyPatchAutocomplete() {
    //var oldFn = $.ui.autocomplete.prototype._renderItem;

    $.ui.autocomplete.prototype._renderItem = function (ul, item) {
      var re = new RegExp(this.term, "i"); //"^" + this.term Сопоставляется в началом ввода.
      var t = item.label.replace(re, "<span style='font-weight:bold;color:Blue;'>" + this.term + "</span>");
      return $("<li></li>")
          .data("item.autocomplete", item)
          .append("<a>" + t + "</a>")
          .appendTo(ul);
    };
  }

  function addMessage(msg) {
    $('#msgs').append(msg);
  }

  $(document).ready(function () {

    monkeyPatchAutocomplete();

    $("#input1").autocomplete({
      source: function (req, responseFn) {
        addMessage("search on: '" + req.term + "'<br/>");
        var re = $.ui.autocomplete.escapeRegex(req.term);
        var matcher = new RegExp(re, "i"); //"^" + re Сопоставляется в началом ввода.
        var a = $.grep(wordlist, function (item, index) {
          return matcher.test(item);
        });
        addMessage("Result: " + a.length + " items<br/>");
        responseFn(a);
      },

      select: function (value, data) {
        if (typeof data == "undefined") {
          addMessage('You selected: ' + value + "<br/>");
        } else {
          addMessage('You selected: ' + data.item.value + "<br/>");
        }
      }
    });

  });

})(window)