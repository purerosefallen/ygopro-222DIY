--哨戒部队
function c13257322.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c13257322.spcost)
	e1:SetCondition(c13257322.spcon)
	e1:SetTarget(c13257322.sptg)
	e1:SetOperation(c13257322.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c13257322.drcon)
	e2:SetTarget(c13257322.drtg)
	e2:SetOperation(c13257322.drop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(13257322,ACTIVITY_SPSUMMON,c13257322.counterfilter)
	
end
function c13257322.counterfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA
end
function c13257322.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(13257322,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c13257322.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c13257322.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA)
end
function c13257322.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x351)
end
function c13257322.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c13257322.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c13257322.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetMZoneCount(1-tp)
	if chk==0 then return ft>0 and not (ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133))
		and Duel.IsPlayerCanSpecialSummonMonster(tp,13257323,0,0x4011,400,400,1,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,0,0)
end
function c13257322.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetMZoneCount(1-tp)
	if ft>0 and not (ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133))
		and Duel.IsPlayerCanSpecialSummonMonster(tp,13257323,0,0x4011,400,400,1,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,1-tp) then
		local g=Group.CreateGroup()
		local fid=c:GetFieldID()
		for i=1,ft do
			local token=Duel.CreateToken(tp,13257323)
			Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
			token:RegisterFlagEffect(13257322,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
			g:AddCard(token)
		end
		Duel.SpecialSummonComplete()
		Duel.Hint(11,0,aux.Stringid(13257322,0))
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g)
		e1:SetCondition(c13257322.descon)
		e1:SetOperation(c13257322.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c13257322.desfilter(c,fid)
	return c:GetFlagEffectLabel(13257322)==fid
end
function c13257322.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c13257322.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c13257322.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c13257322.desfilter,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.Destroy(tg,REASON_EFFECT)
end
function c13257322.cfilter(c,tp)
	return c:IsCode(13257323) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()~=tp
end
function c13257322.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13257322.cfilter,1,nil,tp)
end
function c13257322.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c13257322.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
