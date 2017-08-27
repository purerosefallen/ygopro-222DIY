--元始·飞球之爆震
function c13254045.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE+TIMING_STANDBY_PHASE,TIMING_BATTLE_PHASE)
	e1:SetTarget(c13254045.target)
	e1:SetOperation(c13254045.activate)
	c:RegisterEffect(e1)
end
function c13254045.filter(c,e,tp)
	return c:IsSetCard(0x3356) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13254045.filter1(c,e)
	return c:IsFacedown()
end
function c13254045.filter2(c,e)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c13254045.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local selA=0
	local selB=0
	local sel=0
	if Duel.IsExistingTarget(c13254045.filter1,tp,0,LOCATION_MZONE,1,nil) then 
		selA=1
	end
	if Duel.IsExistingMatchingCard(c13254045.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingTarget(c13254045.filter2,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		selB=1
	end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then  
		e:SetLabel(0)
		return selA==1 or selB==1
	end
	if selA==1 and selB==0 then sel=0 end
	if selA==0 and selB==1 then sel=1 end
	if selA==1 and selB==1 then sel=2 end
	if sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local op=Duel.SelectOption(tp,aux.Stringid(13254045,0),aux.Stringid(13254045,1))
		sel=op
	end
	if sel==0 then
		e:SetLabel(0)
		e:SetCategory(CATEGORY_POSITION+CATEGORY_REMOVE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
		local g=Duel.SelectTarget(tp,c13254045.filter1,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	elseif sel==1 then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectTarget(tp,c13254045.filter2,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function c13254045.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	if e:GetLabel()==0 and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFacedown() then
		Duel.ChangePosition(tc,POS_FACEUP)
		if not tc:IsAbleToRemove() then return end
		Duel.BreakEffect()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	elseif e:GetLabel()==1 and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c13254045.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		end
	end
end

