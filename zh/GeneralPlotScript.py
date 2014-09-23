import ROOT

def getStatBox(histo):
    """Gets the statbox object from the histo."""
    lof = histo.GetListOfFunctions()
    statbox = lof.FindObject('stats')
    try:
        statbox.GetName();
        return statbox
    except ReferenceError:
        print 'getstatbox failed, remember that a histogram only gets a stat box once it is drawn.'
        raise

def moveStatBox( statbox, x1, y1, x2, y2):
    """Moves the statbox to a new location.  Uses the NDC coordinates where the canvas is 1 wide and tall, (0,0) is the bottom left."""
    statbox.SetX1NDC(x1)
    statbox.SetX2NDC(x2)
    statbox.SetY1NDC(y1)
    statbox.SetY2NDC(y2)
