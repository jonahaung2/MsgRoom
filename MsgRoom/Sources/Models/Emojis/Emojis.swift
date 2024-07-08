//
//  Emojis.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/7/24.
//

import Foundation
enum Emojis: String, CaseIterable {
    static let enTypes = ["Suggestion", "Smileys & People", "Animals & Nature", "Food & Drink", "Activity", "Travel & Places", "Objects", "Symbols", "Flags"]
    static let values = Emojis.allCases.map{ Array($0.rawValue).map { String($0) } }
    
    case suggest = ""
    case faceAndPerson = "😀😃😄😁😆😅😂🤣😇😉😊🙂🙃☺😋😌😍🥰😘😗😙😚🥲🤪😜😝😛🤑😎🤓🥸🧐🤠🥳🤡😏😶🫥😐🫤😑😒🙄🤨🤔🤫🤭🫢🫡🤗🫣🤥😳😞😟😤😠😡🤬😔😕🙁☹😬🥺😣😖😫😩🥱😪😮‍💨😮😱😨😰😥😓😯😦😧🥹😢😭🤤🤩😵😵‍💫🥴😲🤯🫠🤐😷🤕🤒🤮🤢🤧🥵🥶😶‍🌫️😴💤😈👿👹👺💩👻💀☠👽🤖🎃😺😸😹😻😼😽🙀😿😾🫶👐🤲🙌👏🙏🤝👍👎👊✊🤛🤜🤞✌🫰🤘🤟👌🤌🤏👈🫳🫴👉👆👇☝✋🤚🖐🖖👋🤙🫲🫱💪🦾🖕🫵✍🤳💅🦵🦿🦶👄🫦🦷👅👂🦻👃👁👀🧠🫀🫁🦴👤👥🗣🫂👶👧🧒👦👩🧑👨👩‍🦱🧑‍🦱👨‍🦱👩‍🦰🧑‍🦰👨‍🦰👱‍♀️👱👱‍♂️👩‍🦳🧑‍🦳👨‍🦳👩‍🦲🧑‍🦲👨‍🦲🧔‍♀️🧔🧔‍♂️👵🧓👴👲👳‍♀️👳👳‍♂️🧕👼👸🫅🤴👰👰‍♀️👰‍♂️🤵‍♀️🤵🤵‍♂️🙇‍♀️🙇🙇‍♂️💁‍♀️💁💁‍♂️🙅‍♀️🙅🙅‍♂️🙆‍♀️🙆🙆‍♂️🤷‍♀️🤷🤷‍♂️🙋‍♀️🙋🙋‍♂️🤦‍♀️🤦🤦‍♂️🧏‍♀️🧏🧏‍♂️🙎‍♀️🙎🙎‍♂️🙍‍♀️🙍🙍‍♂️💇‍♀️💇💇‍♂️💆‍♀️💆💆‍♂️🤰🫄🫃🤱👩‍🍼🧑‍🍼👨‍🍼🧎‍♀️🧎🧎‍♂️🧍‍♀️🧍🧍‍♂️💃🕺👫👭👬🧑‍🤝‍🧑👩‍❤️‍👨👩‍❤️‍👩💑👨‍❤️‍👨👩‍❤️‍💋‍👨👩‍❤️‍💋‍👩💏👨‍❤️‍💋‍👨❤🧡💛💚💙💜🤎🖤🤍💔❣💕💞💓💗💖💘💝❤️‍🔥❤️‍🩹💟"
    case animalAndNature = "🐶🐱🐭🐹🐰🐻🧸🐼🐻‍❄️🐨🐯🦁🐮🐷🐽🐸🐵🙈🙉🙊🐒🦍🦧🐔🐧🐦🐤🐣🐥🐺🦊🦝🐗🐴🦓🦒🦌🦘🦥🦦🦫🦄🐝🐛🦋🐌🪲🐞🐜🦗🪳🕷🕸🦂🦟🪰🪱🦠🐢🐍🦎🐙🦑🦞🦀🦐🦪🐠🐟🐡🐬🦈🦭🐳🐋🐊🐆🐅🐃🐂🐄🦬🐪🐫🦙🐘🦏🦛🦣🐐🐏🐑🐎🐖🦇🐓🦃🕊🦅🦆🦢🦉🦩🦚🦜🦤🪶🐕🦮🐕‍🦺🐩🐈🐈‍⬛🐇🐀🐁🐿🦨🦡🦔🐾🐉🐲🦕🦖🌵🎄🌲🌳🌴🪴🌱🌿☘🍀🎍🎋🍃🍂🍁🌾🪺🪹🌺🌻🌹🥀🌷🌼🌸🪷💐🍄🐚🪸🌎🌍🌏🌕🌖🌗🌘🌑🌒🌓🌔🌙🌚🌝🌛🌜⭐🌟💫✨☄🪐🌞☀🌤⛅🌥🌦🌧⛈🌩⚡🔥💥❄🌨☃⛄🌬💨🌪🌫🌈☔💧💦🌊"
    case food = "🍏🍎🍐🍊🍋🍌🍉🍇🍓🍈🍒🫐🍑🥭🍍🥥🥝🍅🥑🫒🍆🌶🫑🥒🥬🥦🧄🧅🌽🥕🥗🥔🍠🌰🥜🫘🍯🍞🥐🥖🫓🥨🥯🥞🧇🧀🍗🍖🥩🍤🥚🍳🥓🍔🍟🌭🍕🍝🥪🌮🌯🫔🥙🧆🍜🥘🍲🫕🥫🫙🧂🧈🍥🍣🍱🍛🍙🍚🍘🥟🍢🍡🍧🍨🍦🍰🎂🧁🥧🍮🍭🍬🍫🍿🍩🍪🥠🥮☕🍵🫖🥣🍼🥤🧋🧃🧉🥛🫗🍺🍻🍷🥂🥃🍸🍹🍾🍶🧊🥄🍴🍽🥢🥡"
    case activity = "⚽🏀🏈⚾🥎🎾🏐🏉🎱🥏🪃🏓🏸🥅🏒🏑🏏🥍🥌⛳🏹🎣🤿🥊🥋⛸🎿🛷⛷🏂🏋️‍♀️🏋🏋️‍♂️🤺🤼‍♀️🤼🤼‍♂️🤸‍♀️🤸🤸‍♂️⛹️‍♀️⛹⛹️‍♂️🤾‍♀️🤾🤾‍♂️🧗‍♀️🧗🧗‍♂️🏌️‍♀️🏌🏌️‍♂️🧘‍♀️🧘🧘‍♂️🧖‍♀️🧖🧖‍♂️🏄‍♀️🏄🏄‍♂️🏊‍♀️🏊🏊‍♂️🤽‍♀️🤽🤽‍♂️🚣‍♀️🚣🚣‍♂️🏇🚴‍♀️🚴🚴‍♂️🚵‍♀️🚵🚵‍♂️🎽🎖🏅🥇🥈🥉🏆🏵🎗🎫🎟🎪🤹‍♀️🤹🤹‍♂️🎭🎨🎬🎤🎧🎼🎹🪗🥁🪘🎷🎺🎸🪕🎻🎲🧩♟🎯🎳🪀🪁🛝🎮👾🎰👮‍♀️👮👮‍♂️👩‍🚒🧑‍🚒👨‍🚒👷‍♀️👷👷‍♂️👩‍🏭🧑‍🏭👨‍🏭👩‍🔧🧑‍🔧👨‍🔧👩‍🌾🧑‍🌾👨‍🌾👩‍🍳🧑‍🍳👨‍🍳👩‍🎤🧑‍🎤👨‍🎤👩‍🎨🧑‍🎨👨‍🎨👩‍🏫🧑‍🏫👨‍🏫👩‍🎓🧑‍🎓👨‍🎓👩‍💼🧑‍💼👨‍💼👩‍💻🧑‍💻👨‍💻👩‍🔬🧑‍🔬👨‍🔬👩‍🚀🧑‍🚀👨‍🚀👩‍⚕️🧑‍⚕️👨‍⚕️👩‍⚖️🧑‍⚖️👨‍⚖️👩‍✈️🧑‍✈️👨‍✈️💂‍♀️💂💂‍♂️🥷🕵️‍♀️🕵🕵️‍♂️🤶🧑‍🎄🎅🕴️‍♀️🕴🕴️‍♂️🦸‍♀️🦸🦸‍♂️🦹‍♀️🦹🦹‍♂️🧙‍♀️🧙🧙‍♂️🧝‍♀️🧝🧝‍♂️🧚‍♀️🧚🧚‍♂️🧞‍♀️🧞🧞‍♂️🧜‍♀️🧜🧜‍♂️🧌🧛‍♀️🧛🧛‍♂️🧟‍♀️🧟🧟‍♂️🚶‍♀️🚶🚶‍♂️👩‍🦯🧑‍🦯👨‍🦯🏃‍♀️🏃🏃‍♂️👩‍🦼🧑‍🦼👨‍🦼👩‍🦽🧑‍🦽👨‍🦽👯‍♀️👯👯‍♂️👪👨‍👩‍👧👨‍👩‍👧‍👦👨‍👩‍👦‍👦👨‍👩‍👧‍👧👩‍👩‍👦👩‍👩‍👧👩‍👩‍👧‍👦👩‍👩‍👦‍👦👩‍👩‍👧‍👧👨‍👨‍👦👨‍👨‍👧👨‍👨‍👧‍👦👨‍👨‍👦‍👦👨‍👨‍👧‍👧👩‍👦👩‍👧👩‍👧‍👦👩‍👦‍👦👩‍👧‍👧👨‍👦👨‍👧👨‍👧‍👦👨‍👦‍👦👨‍👧‍👧"
    case travel = "🚗🚙🚕🛺🚌🚎🏎🚓🚑🚒🚐🛻🚚🚛🚜🏍🛵🚲🦼🦽🛴🛹🛼🛞🚨🚔🚍🚘🚖🚡🚠🚟🚃🚋🚝🚄🚅🚈🚞🚂🚆🚇🚊🚉🚁🛩✈🛫🛬🪂💺🛰🚀🛸🛶⛵🛥🚤⛴🛳🚢🛟⚓⛽🚧🚏🚦🚥🛑🎡🎢🎠🏗🌁🗼🏭⛲🎑⛰🏔🗻🌋🗾🏕⛺🏞🛣🛤🌅🌄🏜🏖🏝🌇🌆🏙🌃🌉🌌🌠🎇🎆🛖🏘🏰🏯🏟🗽🏠🏡🏚🏢🏬🏣🏤🏥🏦🏨🏪🏫🏩💒🏛⛪🕌🛕🕍🕋⛩"
    case individual = "⌚📱📲💻⌨🖥🖨🖱🖲🕹🗜💽💾💿📀📼📷📸📹🎥📽🎞📞☎📟📠📺📻🎙🎚🎛⏱⏲⏰🕰⏳⌛🧮📡🔋🪫🔌💡🔦🕯🧯🗑🛢🛒💸💵💴💶💷💰🪙💳🪪🧾💎⚖🦯🧰🔧🪛🔨⚒🛠⛏🪓🪚🔩⚙⛓🪝🪜🧱🪨🪵🔫🧨💣🔪🗡⚔🛡🚬⚰🪦⚱🏺🔮🪄📿🧿🪬💈🧲⚗🧪🧫🧬🔭🔬🕳🩻💊💉🩸🩹🩺🌡🩼🏷🔖🚽🪠🚿🛁🛀🪥🪒🧴🧻🧼🫧🧽🧹🧺🪣🔑🗝🪤🛋🪑🛌🛏🚪🪞🪟🧳🛎🖼🧭🗺⛱🗿🛍🎈🎏🎀🧧🎁🎊🎉🪅🪩🪆🎎🎐🏮🪔✉📩📨📧💌📮📪📫📬📭📦📯📥📤📜📃📑📊📈📉📄📅📆🗓📇🗃🗳🗄📋🗒📁📂🗂🗞📰🪧📓📕📗📘📙📔📒📚📖🔗📎🖇✂📐📏📌📍🧷🪡🧵🧶🪢🔐🔒🔓🔏🖊🖋✒📝✏🖍🖌🔍🔎👚👕🥼🦺🧥👖👔👗👘🥻🩱👙🩲🩳💄💋👣🧦🩴👠👡👢🥿👞👟🩰🥾🧢👒🎩🎓👑⛑🪖🎒👝👛👜💼👓🕶🥽🧣🧤💍🌂☂"
    case sign = "🆔📳🈶🈚🈸🈺🈷🆚🆘⛔📛🚫❌⭕💢♨🚷🚯🚳🚱🔞📵🚭❗❕❓❔‼⁉💯🔅⚠🚸🔰♻🈯💹❇✳❎✅💠🌀➿🌐♾Ⓜ🏧🚾♿🅿🈳🈂🛂🛃🛄🛅🚰🛗🚹🚺🚼🚻🚮🎦📶🈁🆖🆗🆙🆒🆕🆓0️⃣1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣7️⃣8️⃣9️⃣🔟🔢⏸⏯⏹⏺⏭⏮⏩⏪🔀🔁🔂🔼🔽⏫⏬🔄🔤🔡🔠🔣🎵🎶〰➰✔➕➖➗✖🟰💲💱🔚🔙🔛🔝🔜☑🔘🔴🟠🟡🟢🔵🟣🟤⚫⚪🟥🟧🟨🟩🟦🟪🟫⬛⬜🔺🔻🔲🔳🔈🔉🔊🔇📣📢🔔🔕🃏🀄♠♣♥♦🎴👁‍🗨🗨💭🗯💬"
    case flag = "🏳🏴🏁🚩🎌🏴‍☠️🏳️‍🌈🏳️‍⚧️🇦🇨🇦🇩🇦🇪🇦🇫🇦🇬🇦🇮🇦🇱🇦🇲🇦🇴🇦🇶🇦🇷🇦🇸🇦🇹🇦🇺🇦🇼🇦🇽🇦🇿🇧🇦🇧🇧🇧🇩🇧🇪🇧🇫🇧🇬🇧🇭🇧🇮🇧🇯🇧🇱🇧🇲🇧🇳🇧🇴🇧🇶🇧🇷🇧🇸🇧🇹🇧🇼🇧🇾🇧🇿🇨🇦🇨🇨🇨🇩🇨🇫🇨🇬🇨🇭🇨🇮🇨🇰🇨🇱🇨🇲🇨🇳🇨🇴🇨🇷🇨🇺🇨🇻🇨🇼🇨🇽🇨🇾🇨🇿🇩🇪🇩🇯🇩🇰🇩🇲🇩🇴🇩🇿🇪🇨🏴󠁧󠁢󠁥󠁮󠁧󠁿🇪🇪🇪🇬🇪🇭🇪🇷🇪🇸🇪🇹🇪🇺🇫🇮🇫🇯🇫🇰🇫🇲🇫🇴🇫🇷🇬🇦🇬🇧🇬🇩🇬🇪🇬🇫🇬🇬🇬🇭🇬🇮🇬🇱🇬🇲🇬🇳🇬🇵🇬🇶🇬🇷🇬🇸🇬🇹🇬🇺🇬🇼🇬🇾🇭🇰🇭🇳🇭🇷🇭🇹🇭🇺🇮🇨🇮🇩🇮🇪🇮🇱🇮🇲🇮🇳🇮🇴🇮🇶🇮🇷🇮🇸🇮🇹🇯🇪🇯🇲🇯🇴🇯🇵🇰🇪🇰🇬🇰🇭🇰🇮🇰🇲🇰🇳🇰🇵🇰🇷🇰🇼🇰🇾🇰🇿🇱🇦🇱🇧🇱🇨🇱🇮🇱🇰🇱🇷🇱🇸🇱🇹🇱🇺🇱🇻🇱🇾🇲🇦🇲🇨🇲🇩🇲🇪🇲🇬🇲🇭🇲🇰🇲🇱🇲🇲🇲🇳🇲🇴🇲🇵🇲🇶🇲🇷🇲🇸🇲🇹🇲🇺🇲🇻🇲🇼🇲🇽🇲🇾🇲🇿🇳🇦🇳🇨🇳🇪🇳🇫🇳🇬🇳🇮🇳🇱🇳🇴🇳🇵🇳🇷🇳🇺🇳🇿🇴🇲🇵🇦🇵🇪🇵🇫🇵🇬🇵🇭🇵🇰🇵🇱🇵🇲🇵🇳🇵🇷🇵🇸🇵🇹🇵🇼🇵🇾🇶🇦🇷🇪🇷🇴🇷🇸🇷🇺🇷🇼🇸🇦🏴󠁧󠁢󠁳󠁣󠁴󠁿🇸🇧🇸🇨🇸🇩🇸🇪🇸🇬🇸🇭🇸🇮🇸🇰🇸🇱🇸🇲🇸🇳🇸🇴🇸🇷🇸🇸🇸🇹🇸🇻🇸🇽🇸🇾🇸🇿🇹🇦🇹🇨🇹🇩🇹🇫🇹🇬🇹🇭🇹🇯🇹🇰🇹🇱🇹🇲🇹🇳🇹🇴🇹🇷🇹🇹🇹🇻🇹🇼🇹🇿🇺🇦🇺🇬🇺🇳🇺🇸🇺🇾🇺🇿🇻🇦🇻🇨🇻🇪🇻🇬🇻🇮🇻🇳🇻🇺🏴󠁧󠁢󠁷󠁬󠁳󠁿🇼🇫🇼🇸🇽🇰🇾🇪🇾🇹🇿🇦🇿🇲🇿🇼"
}