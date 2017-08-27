--红飞球
function c13254034.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13254034,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,13254034)
	e1:SetTarget(c13254034.sptg)
	e1:SetOperation(c13254034.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13254034,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c13254034.descon)
	e3:SetTarget(c13254034.destg)
	e3:SetOperation(c13254034.desop)
	c:RegisterEffect(e3)
end
function c13254034.filter(c,e,tp)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13254034.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c13254034.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c13254034.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c13254034.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c13254034.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c13254034.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) or c:IsPreviousLocation(LOCATION_HAND)
end
function c13254034.desfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c13254034.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254034.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c13254034.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg=g:GetMinGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c13254034.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13254034.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMinGroup(Card.GetAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			local tc=sg:GetFirst()
			local atk=tc:IsFaceup() and tc:GetAttack() or 0
			if Duel.Destroy(sg,REASON_EFFECT)==1 and atk~=0
				then Duel.Recover(tp,atk,REASON_EFFECT)
			end
		else
			local tc=tg:GetFirst()
			local atk=tc:IsFaceup() and tc:GetAttack() or 0
			if Duel.Destroy(tg,REASON_EFFECT)==1 and atk~=0 
				then Duel.Recover(tp,atk,REASON_EFFECT)
			end
		end
	end
end
