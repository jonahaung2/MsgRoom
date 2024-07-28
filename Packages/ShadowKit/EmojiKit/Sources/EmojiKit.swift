//
//  File.swift
//  
//
//  Created by Aung Ko Min on 16/7/24.
//

import Foundation
public enum Emojis: String, CaseIterable {
    public static let enTypes = ["Suggestion", "Smileys & People", "Animals & Nature", "Food & Drink", "Activity", "Travel & Places", "Objects", "Symbols", "Flags"]
    public static let values = Emojis.allCases.map{ Array($0.rawValue).map { String($0) } }
    
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