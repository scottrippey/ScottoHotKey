Imports System.Text.RegularExpressions

Module Module1

  Sub Main(ByVal args() As String)
    'For Each arg As String In args
    '  Console.WriteLine(arg)
    'Next
    If args.Length <> 4 Then
      Console.Error.WriteLine("There should be 3 arguments: Source, Dest, Regular Expression, Replacement String.")
#If DEBUG Then
      Console.Read()
#End If
      Return
    End If

    Dim source As String, dest As String, rx As Regex, replacement As String

    source = args(0)
    dest = args(1)
    If Not IO.File.Exists(source) Then
      Console.Error.WriteLine("The source file does not exist (" & source & ")")
#If DEBUG Then
      Console.Read()
#End If
      Return
    End If
    If IO.File.Exists(dest) Then
      Console.Error.WriteLine("The dest file already exists (" & dest & ")")
#If DEBUG Then
      Console.Read()
#End If
      Return
    End If

    Try
      rx = New Regex(args(2), RegexOptions.IgnoreCase Or RegexOptions.Compiled)
    Catch ex As Exception
      Console.Error.Write("The Regular Expression is invalid (""" & args(2) & """)")
#If DEBUG Then
      Console.Read()
#End If
      Return
    End Try

    replacement = args(3)




    Dim fileContents$ = IO.File.ReadAllText(source, System.Text.Encoding.Default)

    fileContents = rx.Replace(fileContents, replacement)

    IO.File.WriteAllText(dest, fileContents, System.Text.Encoding.Default)

    Console.WriteLine("The file was successfully modified")

  End Sub

End Module
