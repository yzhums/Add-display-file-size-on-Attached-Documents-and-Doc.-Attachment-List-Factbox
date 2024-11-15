tableextension 50112 DocumentAttachmentExt extends "Document Attachment"
{
    fields
    {
        field(50100; FileSizeTxt; Text[100])
        {
            Caption = 'File Size';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
}
pageextension 50112 DocumentAttachmentDetailsExt extends "Document Attachment Details"
{
    layout
    {
        addafter("File Type")
        {
            field(FileSizeTxt; Rec.FileSizeTxt)
            {
                ApplicationArea = All;
                Caption = 'File Size';
                Editable = false;
                ToolTip = 'The size of the file in KB or MB';
            }
        }
    }
}

pageextension 50113 DocAttachmentListFactboxExt extends "Doc. Attachment List Factbox"
{
    layout
    {
        addafter("File Extension")
        {
            field(FileSizeTxt; Rec.FileSizeTxt)
            {
                ApplicationArea = All;
                Caption = 'File Size';
                Editable = false;
                ToolTip = 'The size of the file in KB or MB';
            }
        }
    }
}

codeunit 50112 AttachmentHandler
{
    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", OnBeforeSaveAttachment, '', false, false)]
    local procedure OnBeforeSaveAttachment(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef; var FileName: Text; var TempBlob: Codeunit "Temp Blob")
    begin
        DocumentAttachment.FileSizeTxt := FormatFileSize(TempBlob.Length());
    end;

    var
        FileSizeTxt: Label '%1 %2', Comment = '%1 = File Size, %2 = Unit of measurement', Locked = true;

    local procedure FormatFileSize(SizeInBytes: Integer): Text
    var
        FileSizeConverted: Decimal;
        FileSizeUnit: Text;
    begin
        FileSizeConverted := SizeInBytes / 1024; // The smallest size we show is KB
        if FileSizeConverted < 1024 then
            FileSizeUnit := 'KB'
        else begin
            FileSizeConverted := FileSizeConverted / 1024; // The largest size we show is MB
            FileSizeUnit := 'MB'
        end;
        exit(StrSubstNo(FileSizeTxt, Round(FileSizeConverted, 0.01, '>'), FileSizeUnit));
    end;
}
