--岚龙剑
function c10173067.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_DRAGON),1)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10173067,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10173067)
	e1:SetTarget(c10173067.eqtg)
	e1:SetOperation(c10173067.eqop)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10173067,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10173167)
	e2:SetTarget(c10173067.tdtg)
	e2:SetOperation(c10173067.tdop)
	c:RegisterEffect(e2)
end
function c10173067.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c10173067.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c10173067.eqfilter1(c)
	return bit.band(c:GetType(),0x40002)==0x40002 and c:IsFaceup()
end
function c10173067.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10173067.eqfilter1,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc1=Duel.SelectTarget(tp,c10173067.eqfilter1,tp,LOCATION_REMOVED,0,1,1,nil):GetFirst()
	e:SetLabelObject(tc1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc2=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc1:CheckEquipTarget(tc2) then
	   Duel.SetOperationInfo(0,CATEGORY_EQUIP,tc1,1,0,LOCATION_REMOVED)
	else
	   Duel.SetOperationInfo(0,CATEGORY_TOHAND,Group.FromCards(tc1,tc2),2,0,0)
	end
end
function c10173067.eqop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==ec then tc=g:GetNext() end
	if ec:IsFaceup() and ec:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
	   if ec:CheckEquipTarget(tc) then
		  Duel.Equip(tp,ec,tc)
	   else
		  Duel.SendtoHand(g,nil,REASON_EFFECT)
	   end
	end
end
