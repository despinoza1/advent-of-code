Imports System.Text.RegularExpressions
Imports System.IO

Module Module1
    Private Const MAX_RED As UInteger = 12
    Private Const MAX_GREEN As UInteger = 13
    Private Const MAX_BLUE As UInteger = 14

    Private regxr As Regex = new Regex(
            "(?<round>(\d+ (blue|red|green)(, )?)+(;|))+",
            RegexOptions.ExplicitCapture)

    Function checkRound(round As String) As Boolean
        Dim colors As String() = round.Split(", ")

        For Each color As String in colors
           Console.WriteLine(color.Replace(";", ""))
           Dim cubes As String() = color.Split(" ") 
           Select cubes(1).Replace(";", "") 
               Case "red"
                   If UInteger.Parse(cubes(0)) > MAX_RED Then
                       Return False
                   End If
               Case "green"
                   If UInteger.Parse(cubes(0)) > MAX_GREEN Then
                       Return False
                   End If
               Case "blue"
                   If UInteger.Parse(cubes(0)) > MAX_BLUE Then
                       Return False
                   End If
           End Select

        Next color

        Return True
    End Function

    Function getMatch(text As String) As UInteger
        Dim isValid as Boolean = True
        Console.WriteLine(text)

        Dim game As String() = text.Split(": ")
        Dim mc As MatchCollection = regxr.Matches(game(1))

        Dim min_red As UInteger = 0
        Dim min_green As UInteger = 0
        Dim min_blue As UInteger = 0

        For i As Byte = 0 To mc.Count-1
            Dim match As Match = mc.Item(i)
            ' isValid = isValid And checkRound(match.Groups("round").Value)
            
            Dim round As String = match.Groups("round").Value
            Dim colors As String() = round.Split(", ")
            For Each color As String in colors
               Dim cubes As String() = color.Split(" ") 
               Dim cube_val As UInteger = UInteger.Parse(cubes(0))
               Select cubes(1).Replace(";", "") 
                   Case "red"
                       If cube_val > min_red Then
                           min_red = cube_val
                       End If
                   Case "green"
                       If cube_val > min_green Then
                           min_green = cube_val
                       End If
                   Case "blue"
                       If cube_val > min_blue Then
                           min_blue = cube_val
                       End If
               End Select

            Next color
        Next 

        Return min_red * min_green * min_blue

        ' If isValid Then
        '     Return UInteger.Parse(game(0).Split(" ")(1))
        ' End If

        ' Console.WriteLine("Value greater than max")
        ' Return 0
    End Function

    Public Sub Main(cmdArgs As String())
        If cmdArgs.Length < 1 Then
            Console.WriteLine("Usage ./soln.exe <filename>")
            Return
        End If

        Dim sum As UInteger = 0

        Using Reader As New StreamReader(cmdArgs(0))
            While Reader.EndOfStream = False
                sum += getMatch(Reader.ReadLine())
            End While
        End Using

        Console.WriteLine("Total Sum = {0}", sum)
    End Sub

End Module
