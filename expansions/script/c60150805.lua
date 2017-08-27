--爱莎-平安夜
function c60150805.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c60150805.spcon)
	e1:SetCost(c60150805.spcost)
	e1:SetTarget(c60150805.sptg)
	e1:SetOperation(c60150805.spop)
	c:RegisterEffect(e1)
	--素材
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c60150805.efcon)
	e3:SetOperation(c60150805.efop)
	c:RegisterEffect(e3)
end
function c60150805.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	return ep~=tp and Duel.GetTurnPlayer()==tp and re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c60150805.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(60150805)==0 end
	e:GetHandler():RegisterFlagEffect(60150805,RESET_CHAIN,0,1)
end
function c60150805.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,LOCATION_DECK,1,nil)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c60150805.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		if Duel.SpecialSummon(e:GetHandler(),1,tp,tp,false,false,POS_FACEUP) then Duel.BreakEffect()
			--xyz limit
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			e4:SetReset(RESET_EVENT+0xfe0000)
			e4:SetValue(c60150805.xyzlimit)
			e:GetHandler():RegisterEffect(e4)
			Duel.SpecialSummonComplete()
			local c=e:GetHandler()
			local res=0
			res=Duel.TossCoin(tp,1)
			if res==0 then
				local g=Duel.GetFieldCard(tp,LOCATION_DECK,0)
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
			if res==1 then
				local g=Duel.GetFieldCard(1-tp,LOCATION_DECK,0)
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end 
		end
	end
end
function c60150805.xyzlimit(e,c)
	if not c then return false end
	return not (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER))
end
function c60150805.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsSetCard(0x3b23) and c:IsAttribute(ATTRIBUTE_DARK))
end
function c60150805.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c60150805.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(60150502,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c60150805.con)
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
function c60150805.con(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end