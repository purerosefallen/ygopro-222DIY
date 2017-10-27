--智飞球
function c13254041.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(c13254041.sfilter))
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13254041,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c13254041.tktg)
	e2:SetOperation(c13254041.tkop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,13254041)
	e3:SetTarget(c13254041.retg)
	e3:SetOperation(c13254041.reop)
	c:RegisterEffect(e3)
end
function c13254041.sfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254041.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,13254083,0x356,0x4011,300,200,1,RACE_FAIRY,ATTRIBUTE_EARTH) and Duel.GetMZoneCount(tp)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c13254041.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetMZoneCount(tp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if ft>ct then ft=ct end
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,13254083,0x356,0x4011,300,200,1,RACE_FAIRY,ATTRIBUTE_EARTH) then return end
	local ctn=true
	while ft>0 and ctn do
		local token=Duel.CreateToken(tp,13254083)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local fid=c:GetFieldID()
		--cannot release
		local e11=Effect.CreateEffect(c)
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e11:SetRange(LOCATION_MZONE)
		e11:SetCode(EFFECT_UNRELEASABLE_SUM)
		e11:SetValue(1)
		e11:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		token:RegisterEffect(e11,true)
		local e12=e11:Clone()
		e12:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		token:RegisterEffect(e12,true)
		token:RegisterFlagEffect(13254041,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1,fid)
		local e13=Effect.CreateEffect(c)
		e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e13:SetCode(EVENT_PHASE+PHASE_END)
		e13:SetCountLimit(1)
		e13:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e13:SetLabel(fid)
		e13:SetLabelObject(token)
		e13:SetCondition(c13254041.descon)
		e13:SetOperation(c13254041.desop)
		Duel.RegisterEffect(e13,tp)
		ft=ft-1
		if ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(13254041,0)) then ctn=false end
	end
	Duel.SpecialSummonComplete()
end
function c13254041.descon(e,tp,eg,ep,ev,re,r,rp)
	local token=e:GetLabelObject()
	if Duel.GetTurnPlayer()==tp then return false end
	if token:GetFlagEffectLabel(13254041)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c13254041.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c13254041.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c13254041.reop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
