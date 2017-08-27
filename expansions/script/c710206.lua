--风轮的希望
function c710206.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--to deck  
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(c710206.condition)
	e1:SetTarget(c710206.target)
	e1:SetOperation(c710206.operation)
	c:RegisterEffect(e1)
	--announce
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,710206)
	e2:SetTarget(c710206.antg)
	e2:SetOperation(c710206.anop)
	c:RegisterEffect(e2)
end

c710206.is_named_with_WindWheel=1
function c710206.IsWindWheel(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_WindWheel
end

function c710206.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c710206.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,nil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
end
function c710206.operation(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	local sg1=g1:Filter(Card.IsRelateToEffect,nil,e)
	if sg1:GetCount()>0 and Duel.SendtoDeck(sg1,nil,0,REASON_EFFECT)>1 then
		local tc1=sg1:GetFirst()
		local tc2=sg1:GetNext()
		if tc1:GetControler()==tc2:GetControler() and tc1:IsLocation(LOCATION_DECK) and tc2:IsLocation(LOCATION_DECK) then
			Duel.SortDecktop(tp,tc1:GetControler(),2)
		end
	end
end

function c710206.antg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c710206.anop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tc:IsCode(ac) then
		if tc:IsAbleToHand() then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ShuffleHand(tp)
		else
			Duel.SendtoGrave(tc,REASON_RULE)
		end
	else
		if tc:IsAbleToGrave() and Duel.SelectOption(tp,aux.Stringid(710206,3),aux.Stringid(710206,4))==1 then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
