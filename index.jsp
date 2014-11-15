<html>
    <head>
        <title>Cross Tabulation</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" />
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="jquery.js" type="text/javascript"></script>
		<script src="jquery.csv-0.71" type="text/javascript"></script>
			<script src="jquery-1.11.0" type="text/javascript"></script>
        <link rel="stylesheet" type="text/css" href="bootstrap.min.css" />
    </head>

    <body>
        <h1 style="color: #800000">File Uploader
        </h1>
        <fieldset>
            <legend style="color: #800000">Upload your CSV File</legend> 
            <span class="btn btn-success fileinput-button">
                <i class="glyphicon glyphicon-plus"></i>
                <span>Add files</span>
                <input type="file" name="filename" id="filename" accept=".csv"/>
                <label id="elbl1"></label>
            </span>
        </fieldset>

        <table id="csvTable" class="table"></table>
        <select id="Selection1">
        </select>&nbsp;&nbsp;&nbsp;<select id="Selection2">
        </select>
        <br><br><br>
        <button type="button" class="btn btn-success dropdown-toggle" id="convert">
            <i class="glyphicon glyphicon-circle-arrow-right"></i>
            <span>Perform Cross Tabulation</span>
        </button>
        <table id="converted" class="table">
        </table>
        <br><br><br>
        <div id="csvimporthint"></div> 
    </body>


    <script>

        var data;
        function GetUnique(inputArray)
        {
            var outputArray = [];
            for (var i = 0; i < inputArray.length; i++)
            {
                if ((jQuery.inArray(inputArray[i], outputArray)) === -1)
                {
                    outputArray.push(inputArray[i]);
                }
            }
            return outputArray;
        }


        $("#filename").change(function(e) {
            var ext = $("input#filename").val().split(".").pop().toLowerCase();

            if ($.inArray(ext, ["csv"]) == -1) {
                alert('Upload CSV');
                return false;
            }

            if (e.target.files != undefined) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    var csvval = e.target.result;
                    data = CSVToArray(csvval);

                    var p = data.length;
                    var j = data[0].length;
                    var test = data[1][j - 1];
                    /* for (var i = 0; i < GetUnique(test).length; i++)
                     {
                     //document.write(GetUnique(test)[i]); 
                     }*/
                    if (data && data.length > 0)
                    {
                        alert("Uploaded row-" + data.length + "Sucessfully");
                        var html = '';
                        var selection1 = '';
                        var selection2 = '';
                        for (var q = 0; q < p; q++)
                        {
                            if (q === 0)
                            {
                                html += "<thead><tr>";
                                for (var n = 0; n < j; n++)
                                {
                                    html += "<th>";
                                    html += data[q][n] + " ";
                                    if (n < j - 1) {
                                        selection1 += '<option value=' + n + '>' + data[q][n + 1] + '</option>';
                                        selection2 += '<option value=' + n + '>' + data[q][n + 1] + '</option>';
                                    }
                                    html += "</th>";
                                }
                                html += "</tr></thead>";
                                html += "<br>";
                            } else
                            {
                                html += "<tbody><tr class='active'>";
                                for (var n = 0; n < j; n++)
                                {
                                    html += "<td>";
                                    html += data[q][n] + " ";
                                    html += "</td>";
                                }
                                html += "</tr></tbody>";
                            }
                        }
                        $('#csvTable').append(html);
                        $('#Selection1').append(selection1);
                        $('#Selection2').append(selection2);
                    }
                    function CSVToArray(strData, strDelimiter) {
                        strDelimiter = (strDelimiter || ",");

                        var objPattern = new RegExp(
                                (
                                        "(\\" + strDelimiter + "|\\r?\\n|\\r|^)" +
                                        "(?:\"([^\"]*(?:\"\"[^\"]*)*)\"|" +
                                        "([^\"\\" + strDelimiter + "\\r\\n]*))"
                                        ),
                                "gi"
                                );

                        var arrData = [[]];
                        var arrMatches = null;
                        while (arrMatches = objPattern.exec(strData)) {
                            var strMatchedDelimiter = arrMatches[ 1 ];
                            if (
                                    strMatchedDelimiter.length &&
                                    strMatchedDelimiter !== strDelimiter
                                    ) {
                                arrData.push([]);

                            }

                            var strMatchedValue;
                            if (arrMatches[ 2 ]) {
                                strMatchedValue = arrMatches[ 2 ].replace(
                                        new RegExp("\"\"", "g"),
                                        "\""
                                        );

                            } else {
                                strMatchedValue = arrMatches[ 3 ];
                            }
                            arrData[ arrData.length - 1 ].push(strMatchedValue);
                        }
                        // Return the parsed data.
                        return(arrData);
                    }

                    $("#convert").click(
                            function() {
                                var col1 = parseInt($("#Selection1").val());
                                var col2 = parseInt($("#Selection2").val());
                                var html = '';
                                var row = '';
                                var colh1 = '';
                                var colc1 = '';
                                var tot = 0;
                                var c1 = new Array();
                                for (var i = 1; i < data[0][col1].length; i++)
                                {

                                    c1.push(data[i][col1 + 1]);
                                }

                                c1 = GetUnique(c1);

                                var c2 = new Array();
                                for (var i = 1; i < data[0][col2].length; i++)
                                {

                                    c2.push(data[i][col2 + 1]);
                                }
                                c2 = GetUnique(c2);
                                var count1 = 0;
                                var c3 = new Array(c1.length);
                                col1++;
                                col2++;
                                row += '<thead><tr><th></th>';
                                for (var i = 0; i < c2.length; i++)
                                {
                                    row += '<th>' + c2[i] + '</th>';
                                }
                                row += '<th>Total</th>';
                                row += '</tr></thead><tbody>';
                                for (var v = 0; v < c1.length; v++)
                                {
                                    tot = 0;
                                    row += '<tr><th>' + c1[v] + '</th>';
                                    for (var o = 0; o < c2.length; o++)
                                    {
                                        count1 = 0;
                                        for (var i = 0; i < data.length; i++)
                                        {
                                            if (c1[v] === data[i][col1] && c2[o] === data[i][col2])
                                                count1++;

                                        }
                                        tot = tot + count1;
                                        row += '<td>' + count1 + '</td>';
                                    }
                                    row += '<td>' + tot + '</td></tr>';
                                }

                                row += '<tr><th>Total</th>';

                                for (var m = 0; m < c2.length; m++)
                                {
                                    var i = 0;
                                    for (var o = 1; o < data.length; o++)
                                    {
                                        if (data[o][col2] === c2[m])
                                        {
                                            i++;
                                        }
                                    }
                                    row += '<td>' + i + '</td>';
                                }

                                row += '<td>' + (data.length - 1) + '</td></tr></tbody>';
                                $('#converted').append(row);
                            }

                    );

                };
                reader.readAsText(e.target.files.item(0));

            }

            return false;

        });
    </script>
</html>