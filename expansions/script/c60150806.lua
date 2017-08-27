--爱莎-终末的誓言
function c60150806.initial_effect(c)
	--summon with no tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51126152,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c60150806.ntcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35950025,1))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c60150806.spcon)
	e1:SetTarget(c60150806.sptg)
	e1:SetOperation(c60150806.spop)
	c:RegisterEffect(e1)
end
function c60150806.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c60150806.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_NORMAL+1
end
function c60150806.spfilter(c,e,tp)
	return c:IsSetCard(0x3b23) and c:IsAttribute(ATTRIBUTE_DARK) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end
function c60150806.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,LOCATION_DECK,1,nil)
		and Duel.IsExistingTarget(c60150806.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c60150806.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c60150806.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			--xyz limit
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetDescription(aux.Stringid(60150822,0))
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
			e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			e4:SetValue(c60150806.xyzlimit)
			e4:SetReset(RESET_EVENT+0xfe0000)
			tc:RegisterEffect(e4)
			Duel.SpecialSummonComplete()
			Duel.BreakEffect()
			local c=e:GetHandler()
			local res=0
			res=Duel.TossCoin(tp,1)
			if res==0 then
				local g=Duel.GetFieldCard(tp,LOCATION_DECK,0)
				Duel.DisableShuffleCheck()  
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
			if res==1 then
				local g=Duel.GetFieldCard(1-tp,LOCATION_DECK,0)
				Duel.DisableShuffleCheck()
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end 
		end
	end
end
function c60150806.xyzlimit(e,c)
	if not c then return false end
	return not (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER))
end