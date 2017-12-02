--库拉丽丝-血泪
function c57300009.initial_effect(c)
	c:EnableReviveLimit()
	xpcall(function() require("expansions/script/c57300000") end,function() require("script/c57300000") end)
	miyuki.AddXyzProcedureClariS(c,2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(57300009,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,57300009)
	e2:SetCost(c57300009.tdcost)
	e2:SetTarget(c57300009.tdtg)
	e2:SetOperation(c57300009.tdop)
	c:RegisterEffect(e2)
end
function c57300009.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c57300009.tdfilter(c)
	return c:IsAbleToRemove()
end
function c57300009.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c57300009.tdfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c57300009.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c57300009.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c57300009.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end