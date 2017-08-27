--★大地の魔女っ娘 Rising Earth
function c114000845.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_DESTROY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c114000845.spcon)
	e1:SetTarget(c114000845.sptg)
	e1:SetOperation(c114000845.spop)
	c:RegisterEffect(e1)
end
function c114000845.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and ( c:IsSetCard(0xcabb) or c:IsSetCard(0x1223) ) and c:GetReasonPlayer()~=tp
end
function c114000845.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c114000845.cfilter,1,nil,tp)
end
function c114000845.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c114000845.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_BATTLE_START)
		if Duel.GetTurnPlayer()==c:GetControler() then
			e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		end
		e1:SetCondition(c114000845.descon)
		e1:SetTarget(c114000845.destg)
		e1:SetOperation(c114000845.desop)
		c:RegisterEffect(e1)
	end
end
function c114000845.descon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d==e:GetHandler() then d=Duel.GetAttacker() end
	e:SetLabelObject(d)
	return d~=nil
end
function c114000845.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetLabelObject(),1,0,0)
end
function c114000845.desop(e,tp,eg,ep,ev,re,r,rp)
	local d=e:GetLabelObject()
	if d:IsRelateToBattle() then
		Duel.Destroy(d,REASON_EFFECT)
	end
end
