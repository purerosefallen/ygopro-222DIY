--爱莎-魔女装着
function c60150804.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c60150804.spcon)
	e2:SetOperation(c60150804.spop)
	c:RegisterEffect(e2)
	--素材
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c60150804.efcon)
	e3:SetOperation(c60150804.efop)
	c:RegisterEffect(e3)
	--xyz limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e4:SetValue(c60150804.xyzlimit)
	c:RegisterEffect(e4)
end
function c60150804.spfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x3b23) and c:IsAbleToRemoveAsCost()
end
function c60150804.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c60150804.spfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c60150804.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c60150804.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c60150804.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c60150804.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(60150804,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c60150804.atkcon)
	e1:SetTarget(c60150804.target)
	e1:SetOperation(c60150804.atkop)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_LEAVE)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_XYZ)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2)
	end
end
function c60150804.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x3b23) and e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c60150804.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0xff,0xff,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c60150804.atkop(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.TossDice(tp,1)
	if dc==1 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if g:GetCount()==0 then return end
		local sg=g:RandomSelect(tp,1)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	end
	if dc==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		end
	end
	if dc==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		end
	end
	if dc==4 then
		local g1=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		if g1:GetCount()>0 then
			Duel.ConfirmCards(tp,g1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,1,nil)
			if g:GetCount()>0 then
				Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
			end
		end
	end
	if dc==5 then
		local g=Duel.GetFieldCard(1-tp,LOCATION_DECK,0)
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	if dc==6 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c60150804.xyzlimit(e,c)
	if not c then return false end
	return not (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER))
end