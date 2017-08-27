--★鬼母の抱擁 天魔・紅葉(もみじ)
function c114100142.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x221),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c114100142.spcon)
	e1:SetCost(c114100142.spcost)
	e1:SetTarget(c114100142.sptg)
	e1:SetOperation(c114100142.spop)
	c:RegisterEffect(e1)
	--leave field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(c114100142.leave)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
end
function c114100142.confilter(c,tp)
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetOwner()==1-tp and ( c:IsLevelBelow(5) or c:IsRankBelow(5) )
end
function c114100142.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c114100142.confilter,1,nil,tp)
end
function c114100142.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c114100142.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			return Duel.IsExistingMatchingCard(c114100142.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c) 
		else
			if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
				return Duel.IsExistingMatchingCard(c114100142.cfilter,tp,LOCATION_MZONE,0,1,c)
			else
				return false
			end
		end
	end
	local g
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		g=Duel.SelectMatchingCard(tp,c114100142.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,c)
	else
		g=Duel.SelectMatchingCard(tp,c114100142.cfilter,tp,LOCATION_MZONE,0,1,1,c)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c114100142.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget()
end
function c114100142.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=eg:Filter(c114100142.confilter,nil,tp)
	local tg=mg:Filter(c114100142.spfilter,nil,e,tp)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and tg:IsContains(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and tg:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,1,0,LOCATION_GRAVE)
end

function c114100142.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			if c:IsRelateToEffect(e) then
				c:SetCardTarget(tc)
				e:GetLabelObject():SetLabelObject(tc)
				c:CreateRelation(tc,RESET_EVENT+0x5020000)
				tc:CreateRelation(c,RESET_EVENT+0x1fe0000)
			end
		end
	end
end

function c114100142.leave(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc and c:IsRelateToCard(tc) and tc:IsRelateToCard(c) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
