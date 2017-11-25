--Solid 一零零二
function c22240122.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,0x81),4,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22240122,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c22240122.xyzcon)
	e1:SetOperation(c22240122.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--To Hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22240122,1))
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_RELEASE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_REMOVE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c22240122.thcon1)
	e4:SetCost(c22240122.thcost1)
	e4:SetTarget(c22240122.thtg)
	e4:SetOperation(c22240122.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e5)
	--disable special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22240122,2))
	e6:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_SPSUMMON)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,22240122)
	e6:SetCondition(c22240122.discon)
	e6:SetCost(c22240122.discost)
	e6:SetTarget(c22240122.distg)
	e6:SetOperation(c22240122.disop)
	c:RegisterEffect(e6)
end
c22240122.named_with_Solid=1
function c22240122.IsSolid(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Solid
end
function c22240122.xyzfilter(c,xyzc)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyzc) and bit.band(c:GetOriginalType(),0x81)==0x81
end
function c22240122.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_XMATERIAL) then return false end
	local olg=Duel.GetMatchingGroup(c22240122.xyzfilter,tp,LOCATION_SZONE,0,nil,c)
	if olg:GetCount()>=2 and Duel.GetLocationCountFromEx(tp,tp,olg,c)>0 then return true end
end
function c22240122.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local olg=Duel.GetMatchingGroup(c22240122.xyzfilter,tp,LOCATION_SZONE,0,nil,c)
	if olg:GetCount()>=2 and Duel.GetLocationCountFromEx(tp,tp,olg,c)>0 then
		local g=olg:Select(tp,2,2,nil)
		c:SetMaterial(g)
		Duel.Overlay(c,g)
	end
end
function c22240122.cfilter1(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp and c22240122.IsSolid(c) and bit.band(c:GetReason(),REASON_RELEASE)~=0
end
function c22240122.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22240122.cfilter1,1,nil,tp)
end
function c22240122.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c22240122.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22240122.thfilter(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsReleasableByEffect() and c22240122.IsSolid(c)
end
function c22240122.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	local tc=Duel.GetOperatedGroup():GetFirst()
	if c22240122.thfilter(tc) and Duel.SelectYesNo(tp,aux.Stringid(22240122,3)) then
		Duel.BreakEffect()
		Duel.Release(tc,REASON_EFFECT)
	end
end
function c22240122.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c22240122.discfilter(c)
	return c22240122.IsSolid(c) and bit.band(c:GetReason(),REASON_RELEASE)~=0 and c:IsAbleToDeckAsCost()
end
function c22240122.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22240122.discfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c22240122.discfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c22240122.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
end
function c22240122.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
end