--复苏的季风
function c10119007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10119007.target)
	e1:SetOperation(c10119007.activate)
	c:RegisterEffect(e1) 
	--remove overlay replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10119007,1))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c10119007.rcon)
	e2:SetOperation(c10119007.rop)
	c:RegisterEffect(e2)  
end
function c10119007.rcon(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ)
		and re:GetHandlerPlayer()==tp and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WIND) and c:GetOverlayCount()>=ev-1 and e:GetHandler():IsAbleToDeck()
end
function c10119007.rop(e,tp,eg,ep,ev,re,r,rp)
	local ct=bit.band(ev,0xffff)
	if ct==1 then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
	else
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
		re:GetHandler():RemoveOverlayCard(tp,ct-1,ct-1,REASON_COST)
	end
end
function c10119007.filter(c,e,tp)
	return c:IsSetCard(0x6331) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10119007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10119007.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10119007.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10119007.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10119007.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) and tc:IsType(TYPE_XYZ) and Duel.SelectYesNo(tp,aux.Stringid(10119007,0)) then
	   c:CancelToGrave()
	   Duel.Overlay(tc,Group.FromCards(c))
	end
end
