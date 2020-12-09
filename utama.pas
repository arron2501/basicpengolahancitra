unit Utama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ExtDlgs, ComCtrls, Windows;

var
  bitmapR, bitmapG, bitmapB : array [0..1000, 0..1000] of byte;

type

  { TFormUtama }

  TFormUtama = class(TForm)
    ButtonBrightnessDown: TButton;
    ButtonSmoothing: TButton;
    ButtonSharpening: TButton;
    ButtonSketch: TButton;
    ButtonContrast: TButton;
    ButtonBrightnessUp: TButton;
    ButtonInvers: TButton;
    ButtonBinary: TButton;
    ButtonSave: TButton;
    ButtonLoad: TButton;
    ButtonRestore: TButton;
    ButtonGray: TButton;
    Image1: TImage;
    Label1: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    ScrollBox1: TScrollBox;
    procedure ButtonBrightnessDownClick(Sender: TObject);
    procedure ButtonBinaryClick(Sender: TObject);
    procedure ButtonBrightnessUpClick(Sender: TObject);
    procedure ButtonContrastClick(Sender: TObject);
    procedure ButtonGrayClick(Sender: TObject);
    procedure ButtonInversClick(Sender: TObject);
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonSharpeningClick(Sender: TObject);
    procedure ButtonSketchClick(Sender: TObject);
    procedure ButtonSmoothingClick(Sender: TObject);
    procedure ButtonRestoreClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  FormUtama: TFormUtama;

implementation

{$R *.lfm}

{ TFormUtama }

procedure TFormUtama.ButtonLoadClick(Sender: TObject);
var
  x, y: integer;
begin
  if OpenPictureDialog1.Execute then
  begin
    Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    for y:=0 to Image1.Height-1 do
    begin
      for x:=0 to Image1.Width-1 do
      begin
        bitmapR[x,y] := GetRValue(Image1.Canvas.Pixels[x,y]);
        bitmapG[x,y] := GetGValue(Image1.Canvas.Pixels[x,y]);
        bitmapB[x,y] := GetBValue(Image1.Canvas.Pixels[x,y]);
      end;
    end;
  end;
end;

procedure TFormUtama.ButtonInversClick(Sender: TObject);
var
  x, y: integer;
  inversR, inversG, inversB: integer;
begin
  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      inversR := 255 - bitmapR[x,y];
      inversG := 255 - bitmapG[x,y];
      inversB := 255 - bitmapB[x,y];
      Image1.Canvas.Pixels[x,y] := RGB(inversR, inversG, inversB);
    end;
  end;
end;

procedure TFormUtama.ButtonBrightnessUpClick(Sender: TObject);
var
  x, y: integer;
  brightnessR, brightnessG, brightnessB: integer;
begin
  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      brightnessR := bitmapR[x,y] + 100;
      brightnessG := bitmapG[x,y] + 100;
      brightnessB := bitmapB[x,y] + 100;

      if(brightnessR > 255) then
      brightnessR := 255;
      if(brightnessG > 255) then
      brightnessG := 255;
      if(brightnessB > 255) then
      brightnessB := 255;

      Image1.Canvas.Pixels[x,y] := RGB(brightnessR, brightnessG, brightnessB);
    end;
  end;
end;

procedure TFormUtama.ButtonContrastClick(Sender: TObject);
var
  x, y: integer;
  brightnessR, brightnessG, brightnessB: integer;
  gray: byte;
begin
  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      gray := (bitmapR[x,y] + bitmapG[x,y] + bitmapB[x,y]) div 3;
      brightnessR := 2 * (bitmapR[x,y] - gray) + gray;
      brightnessG := 2 * (bitmapG[x,y] - gray) + gray;
      brightnessB := 2 * (bitmapB[x,y] - gray) + gray;

      if(brightnessR > 255) then
      brightnessR := 255;
      if(brightnessG > 255) then
      brightnessG := 255;
      if(brightnessB > 255) then
      brightnessB := 255;

      if(brightnessR < 0) then
      brightnessR := 0;
      if(brightnessG < 0) then
      brightnessG := 0;
      if(brightnessB < 0) then
      brightnessB := 0;

      Image1.Canvas.Pixels[x,y] := RGB(brightnessR, brightnessG, brightnessB);
    end;
  end;
end;

procedure TFormUtama.ButtonBinaryClick(Sender: TObject);
var
  // Inisialisasi variabel yang akan digunakan.
  x, y: integer;
  gray: byte;
begin
  // Looping untuk proses pengolahan gambar.
  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      // Memulai proses pengolahan gambar menjadi Binary Image
      // [1] Mengkonversi gambar ke citra gray terlebih dahulu,
      //     untuk mendapatkan nilai gray dari gambar tersebut.
      gray := (bitmapR[x,y] + bitmapG[x,y] + bitmapB[x,y]) div 3;

      // [2] Setelah mendapatkan nilai graynya, selanjutnya adalah
      //     membuat statement untuk mengubah nilai gray menjadi 0 dan 255.
      //     Apabila nilai gray kurang dari 128, maka nilai gray tersebut
      //     akan diubah menjadi 0, yang merepresentasikan angka biner 0.
      if(gray < 128) then
      gray := 255 else

      //     Namun, apabila nilai gray lebih dari atau sama dengan 128,
      //     maka nilai gray tersebut akan diubah menjadi 255, yang
      //     merepresentasikan angka biner 1, itulah mengapa disebut sebagai
      //     Binary Image, karena gambar hanya akan menampilkan warna hitam dan
      //     putih, yang mengibaratkan angka biner yaitu 0 dan 1.
      gray := 0;

      // [3] Setelah proses perubahan nilai selesai, maka selanjutnya adalah
      //     menginput nilai tersebut kedalam nilai RGB dari gambar tersebut.
      Image1.Canvas.Pixels[x,y] := RGB(gray, gray, gray);
    end;
  end;
end;

procedure TFormUtama.ButtonBrightnessDownClick(Sender: TObject);
var
  x, y: integer;
  brightnessR, brightnessG, brightnessB: integer;
begin
  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      brightnessR := bitmapR[x,y] - 100;
      brightnessG := bitmapG[x,y] - 100;
      brightnessB := bitmapB[x,y] - 100;

      if(brightnessR < 0) then
      brightnessR := 0;
      if(brightnessG < 0) then
      brightnessG := 0;
      if(brightnessB < 0) then
      brightnessB := 0;

      Image1.Canvas.Pixels[x,y] := RGB(brightnessR, brightnessG, brightnessB);
    end;
  end;
end;

procedure TFormUtama.ButtonGrayClick(Sender: TObject);
var
  x, y: integer;
  gray: byte;
begin
  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      gray := (bitmapR[x,y] + bitmapG[x,y] + bitmapB[x,y]) div 3;
      Image1.Canvas.Pixels[x,y] := RGB(gray, gray, gray);
    end;
  end;
end;

procedure TFormUtama.ButtonSaveClick(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
  begin
    Image1.Picture.SaveToFile(SavePictureDialog1.FileName);
  end;
end;

procedure TFormUtama.ButtonSharpeningClick(Sender: TObject);
var
  value : array [0..2,0..2] of integer;
  i, j, r, g, b: integer;
begin
  value[0,0] := 0;
  value[0,1] := -1;
  value[0,2] := 0;
  value[1,0] := -1;
  value[1,1] := 5;
  value[1,2] := -1;
  value[2,0] := 0;
  value[2,1] := -1;
  value[2,2] := 0;

  for j := 1 to Image1.Height do
  begin
    for i := 1 to Image1.Width do
    begin
      r := (bitmapR[i-1,j-1]*value[0,0]+bitmapR[i-1,j]*value[0,1]+bitmapR[i-1,j+1]*value[0,2]+
      bitmapR[i,j-1]*value[1,0]+bitmapR[i,j]*value[1,1]+bitmapR[i,j+1]*value[1,2]+
      bitmapR[i+1,j-1]*value[2,0]+bitmapR[i+1,j]*value[2,1]+bitmapR[i+1,j+1]*value[2,2]);
      if(r>255) then r:=255 else
      if(r<0) then r:=0 else round(r);

      g := (bitmapG[i-1,j-1]*value[0,0]+bitmapG[i-1,j]*value[0,1]+bitmapG[i-1,j+1]*value[0,2]+
      bitmapG[i,j-1]*value[1,0]+bitmapG[i,j]*value[1,1]+bitmapG[i,j+1]*value[1,2]+
      bitmapG[i+1,j-1]*value[2,0]+bitmapG[i+1,j]*value[2,1]+bitmapG[i+1,j+1]*value[2,2]);
      if(g>255) then g:=255 else
      if(g<0) then g:=0 else round(g);

      b := (bitmapB[i-1,j-1]*value[0,0]+bitmapB[i-1,j]*value[0,1]+bitmapB[i-1,j+1]*value[0,2]+
      bitmapB[i,j-1]*value[1,0]+bitmapB[i,j]*value[1,1]+bitmapB[i,j+1]*value[1,2]+
      bitmapB[i+1,j-1]*value[2,0]+bitmapB[i+1,j]*value[2,1]+bitmapB[i+1,j+1]*value[2,2]);
      if(b>255) then b:=255 else
      if(b<0) then b:=0 else round(b);
      Image1.Canvas.Pixels[i,j] := RGB(r, g, b);
    end;
  end;
end;

procedure TFormUtama.ButtonSketchClick(Sender: TObject);
var
  // Inisialisasi variabel yang akan digunakan.
  value : array [0..2, 0..2] of integer;
  i, j, r, g, b: integer;
begin
  // Setting nilai value untuk proses edge detection.
  // Pada kali ini saya menerapkan edge detection
  // dengan operator Sobel Vertical.
  value[0, 0] := 0;
  value[0, 1] := -1;
  value[0, 2] := 0;
  value[1, 0] := -1;
  value[1, 1] := 4;
  value[1, 2] := -1;
  value[2, 0] := 0;
  value[2, 1] := -1;
  value[2, 2] := 0;

  // Looping untuk proses pengolahan gambar.
  for j := 1 to Image1.Height do
  begin
    for i := 1 to Image1.Width do
    begin
      // Memulai proses pengolahan gambar menjadi Sketch (Edge Detection).
      // [1]
      r := (bitmapR[i-1, j-1] * value[0, 0] + bitmapR[i-1, j] * value[0, 1] + bitmapR[i-1, j+1] * value[0, 2] +
            bitmapR[i, j-1] * value[1, 0] + bitmapR[i, j] * value[1, 1] + bitmapR[i, j+1] * value[1, 2] +
            bitmapR[i+1, j-1] * value[2, 0] + bitmapR[i+1, j] * value[2, 1] + bitmapR[i+1, j+1] * value[2, 2]);
      if(r > 255) then r := 255
      else if(r < 0) then r := 0
      else round(r);

      g := (bitmapG[i-1, j-1] * value[0, 0] + bitmapG[i-1, j] * value[0, 1] + bitmapG[i-1, j+1] * value[0, 2] +
            bitmapG[i, j-1] * value[1, 0] + bitmapG[i, j] * value[1, 1] + bitmapG[i, j+1] * value[1, 2] +
            bitmapG[i+1, j-1] * value[2, 0] + bitmapG[i+1, j] * value[2, 1] + bitmapG[i+1, j+1] * value[2, 2]);
      if(g > 255) then g := 255
      else if(g < 0) then g := 0
      else round(g);

      b := (bitmapB[i-1, j-1] * value[0, 0] + bitmapB[i-1, j] * value[0, 1] + bitmapB[i-1, j+1] * value[0, 2] +
            bitmapB[i, j-1] * value[1, 0] + bitmapB[i, j] * value[1, 1] + bitmapB[i, j+1] * value[1, 2] +
            bitmapB[i+1, j-1] * value[2, 0] + bitmapB[i+1, j] * value[2, 1] + bitmapB[i+1, j+1] * value[2, 2]);
      if(b > 255) then b := 255
      else if(b < 0) then b := 0
      else round(b);

      Image1.Canvas.Pixels[i, j] := RGB(r, g, b);
    end;
  end;
end;

procedure TFormUtama.ButtonSmoothingClick(Sender: TObject);
var
  value : array [0..2,0..2] of integer;
  i, j, r, g, b : integer;
begin
  value[0,0] := 1;
  value[0,1] := 1;
  value[0,2] := 1;
  value[1,0] := 1;
  value[1,1] := 1;
  value[1,2] := 1;
  value[2,0] := 1;
  value[2,1] := 1;
  value[2,2] := 1;

  for j := 1 to Image1.Height-2 do
  begin
    for i := 1 to Image1.Width-2 do
    begin
      r := (bitmapR[i-1,j-1]*value[0,0]+bitmapR[i-1,j]*value[0,1]+bitmapR[i-1,j+1]*value[0,2]+bitmapR[i,j-1]*value[1,0]+bitmapR[i,j]*value[1,1]+bitmapR[i,j+1]*value[1,2]+bitmapR[i+1,j-1]*value[2,0]+bitmapR[i+1,j]*value[2,1]+bitmapR[i+1,j+1]*value[2,2]) div 9;
      g := (bitmapG[i-1,j-1]*value[0,0]+bitmapG[i-1,j]*value[0,1]+bitmapG[i-1,j+1]*value[0,2]+bitmapG[i,j-1]*value[1,0]+bitmapG[i,j]*value[1,1]+bitmapG[i,j+1]*value[1,2]+bitmapG[i+1,j-1]*value[2,0]+bitmapG[i+1,j]*value[2,1]+bitmapG[i+1,j+1]*value[2,2]) div 9;
      b := (bitmapB[i-1,j-1]*value[0,0]+bitmapB[i-1,j]*value[0,1]+bitmapB[i-1,j+1]*value[0,2]+bitmapB[i,j-1]*value[1,0]+bitmapB[i,j]*value[1,1]+bitmapB[i,j+1]*value[1,2]+bitmapB[i+1,j-1]*value[2,0]+bitmapB[i+1,j]*value[2,1]+bitmapB[i+1,j+1]*value[2,2]) div 9;

      Image1.Canvas.Pixels[i,j] := RGB(r, g, b);
    end;
  end;

end;

procedure TFormUtama.ButtonRestoreClick(Sender: TObject);
var
  x, y: integer;
begin
  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      Image1.Canvas.Pixels[x,y] := RGB(bitmapR[x,y], bitmapG[x,y], bitmapB[x,y]);
    end;
  end;
end;

procedure TFormUtama.FormCreate(Sender: TObject);
begin

end;

end.

