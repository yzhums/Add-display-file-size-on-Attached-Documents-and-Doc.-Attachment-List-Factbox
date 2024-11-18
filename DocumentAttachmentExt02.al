pageextension 50112 DocumentAttachmentDetailsExt extends "Document Attachment Details"
{
    layout
    {
        addafter("File Type")
        {
            field(FileSizeTxt; FileSizeTxt)
            {
                ApplicationArea = All;
                Caption = 'File Size';
                Editable = false;
                ToolTip = 'The size of the file in KB or MB';
            }
        }
    }
    var
        FileSizeTxt: Text;
        AttachmentHandler: Codeunit AttachmentHandler;

    trigger OnAfterGetRecord()
    var
        TenantMedia: Record "Tenant Media";
    begin
        FileSizeTxt := '';
        if TenantMedia.Get(Rec."Document Reference ID".MediaId) then
            FileSizeTxt := AttachmentHandler.FormatFileSize(TenantMedia.Content.Length);
    end;
}

pageextension 50113 DocAttachmentListFactboxExt extends "Doc. Attachment List Factbox"
{
    layout
    {
        addafter("File Extension")
        {
            field(FileSizeTxt; FileSizeTxt)
            {
                ApplicationArea = All;
                Caption = 'File Size';
                Editable = false;
                ToolTip = 'The size of the file in KB or MB';
            }
        }
    }
    var
        FileSizeTxt: Text;
        AttachmentHandler: Codeunit AttachmentHandler;

    trigger OnAfterGetRecord()
    var
        TenantMedia: Record "Tenant Media";
    begin
        FileSizeTxt := '';
        if TenantMedia.Get(Rec."Document Reference ID".MediaId) then
            FileSizeTxt := AttachmentHandler.FormatFileSize(TenantMedia.Content.Length);
    end;
}

codeunit 50112 AttachmentHandler
{
    var
        FileSizeTxt: Label '%1 %2', Comment = '%1 = File Size, %2 = Unit of measurement', Locked = true;

    procedure FormatFileSize(SizeInBytes: Integer): Text
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
