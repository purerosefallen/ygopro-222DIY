--空想星界 星降平原
function c10122003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10122003,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCountLimit(1)
	e2:SetCondition(c10122003.tkcon)
	e2:SetTarget(c10122003.tktg)
	e2:SetOperation(c10122003.tkop)
	c:RegisterEffect(e2)	
end
function c10122003.tkcon(e,tp,eg,ep,ev,re,r,rp)
	local loc,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_CONTROLER)
	return loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and p~=tp
end
function c10122003.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10122003.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetAttacker()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
	or not Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,10122011)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetDescription(aux.Stringid(10122003,3))
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e4:SetDescription(aux.Stringid(10122003,5))
		token:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetDescription(aux.Stringid(10122003,6))
		e5:SetCode(EFFECT_UNRELEASABLE_SUM)
		token:RegisterEffect(e5,true)
		local rc=re:GetHandler()
		if rc:IsFaceup() and rc:IsRelateToEffect(re) then
		   token:SetCardTarget(rc)
		   rc:RegisterFlagEffect(10122003,RESET_EVENT+0x1fe0000,0,0)
		end
		local e6=e1:Clone()
		e6:SetDescription(aux.Stringid(10122003,7))
		e6:SetCode(EFFECT_IMMUNE_EFFECT)
		e6:SetRange(LOCATION_MZONE)
		e6:SetLabelObject(rc)
		e6:SetValue(c10122003.efilter)
		token:RegisterEffect(e6,true)
	end
end
function c10122003.efilter(e,te)
	return te:GetHandler():IsHasCardTarget(e:GetHandler()) and te:GetFlagEffect(10122003)>0
end
function c10122003.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:GetHandler()==e:GetLabelObject() and re:IsHasType(0x7e0) and e:GetHandler():GetFlagEffect(10122003)==0 and Duel.CheckLPCost(tp,500)
end

function c10122003.rop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(10122003,RESET_PHASE+PHASE_END,0,1)
	Duel.PayLPCost(tp,500)
end
