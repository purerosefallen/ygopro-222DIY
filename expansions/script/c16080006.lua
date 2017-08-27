--新津 二莎
function c16080006.initial_effect(c)
	--def po
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c16080006.atcon)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5ca))
	c:RegisterEffect(e1)  
	--syn
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetCondition(c16080006.spcon)
	e3:SetTarget(c16080006.sptg)
	e3:SetOperation(c16080006.spop)
	c:RegisterEffect(e3)
end
function c16080006.atcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPosition()==POS_FACEUP_ATTACK 
end
function c16080006.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_CONTINUOUS_POS) and c:IsPosition(POS_FACEUP_ATTACK) and c:IsPreviousPosition(POS_FACEUP_DEFENSE)
end
function c16080006.filter(c,e,tp,lv)
	return c:IsFaceup() and c:GetLevel()>0
		and Duel.IsExistingMatchingCard(c16080006.scfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+c:GetOriginalLevel())
end
function c16080006.scfilter(c,e,tp,lv)
	return c:IsLevelBelow(lv) and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x5ca) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c16080006.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local lv=e:GetHandler():GetOriginalLevel()
	if chk==0 then return Duel.IsExistingTarget(c16080006.filter,tp,0,LOCATION_MZONE,1,nil,e,tp,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c16080006.filter,tp,0,LOCATION_MZONE,1,1,nil,e,tp,lv)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c16080006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local g=Group.FromCards(c,tc)
	if Duel.SendtoGrave(g,REASON_EFFECT)==2 and c:GetLevel()>0 and c:IsLocation(LOCATION_GRAVE)
		and tc:GetLevel()>0 and tc:IsLocation(LOCATION_GRAVE) then
		local lv=c:GetLevel()+tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c16080006.scfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
		local tc=sg:GetFirst()
		if tc then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end