--Solid 一零零四
function c22240124.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,0x81),4,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22240124,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c22240124.xyzcon)
	e1:SetOperation(c22240124.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--Release
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22240124,1))
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c22240124.relcost)
	e1:SetTarget(c22240124.reltg)
	e1:SetOperation(c22240124.relop)
	c:RegisterEffect(e1)
	--Overlay
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22240124,2))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,222401243)
	e1:SetCondition(c22240124.tdcon)
	e1:SetTarget(c22240124.tdtg)
	e1:SetOperation(c22240124.tdop)
	c:RegisterEffect(e1)
end
c22240124.named_with_Solid=1
function c22240124.IsSolid(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Solid
end
function c22240124.xyzfilter(c,xyzc)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyzc) and bit.band(c:GetOriginalType(),0x81)==0x81
end
function c22240124.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local olg=Duel.GetMatchingGroup(c22240124.xyzfilter,tp,LOCATION_SZONE,0,nil,c)
	if olg:GetCount()>=2 and Duel.GetLocationCountFromEx(tp,tp,olg,c)>0 then return true end
end
function c22240124.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local olg=Duel.GetMatchingGroup(c22240124.xyzfilter,tp,LOCATION_SZONE,0,nil,c)
	if olg:GetCount()>=2 and Duel.GetLocationCountFromEx(tp,tp,olg,c)>0 then
		local g=olg:Select(tp,2,2,nil)
		c:SetMaterial(g)
		Duel.Overlay(c,g)
	end
end
function c22240124.relcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,2,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,2,2,REASON_COST)
end
function c22240124.reltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsReleasableByEffect() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function c22240124.relop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Release(tc,REASON_EFFECT)
	end
end
function c22240124.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c22240124.mafilter(c,tp)
	return c22240124.IsSolid(c) and bit.band(c:GetType(),0x81)==0x81 and c:IsCanBeXyzMaterial(nil)
end
function c22240124.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22240124.mafilter,tp,LOCATION_DECK,0,1,nil) end
end
function c22240124.xyzfilter1(c,tp)
	return c22240124.IsSolid(c) and c:IsType(TYPE_XYZ)
end
function c22240124.tdop(e,tp,eg,ep,ev,re,r,rp)
	local xyzg=Duel.GetMatchingGroup(c22240124.xyzfilter1,tp,LOCATION_MZONE,0,nil)
	local m=xyzg:GetCount()
	local mag=Duel.SelectMatchingCard(tp,c22240124.mafilter,tp,LOCATION_DECK,0,1,m,nil)
	while mag:GetCount()>0 and xyzg:GetCount()>0 do
		local tg=xyzg:Select(tp,1,1,nil)
		local mg=mag:Select(tp,1,1,nil)
		Duel.Overlay(tg:GetFirst(),mg:GetFirst())
		xyzg:RemoveCard(tg:GetFirst())
		mag:RemoveCard(mg:GetFirst())
	end
end