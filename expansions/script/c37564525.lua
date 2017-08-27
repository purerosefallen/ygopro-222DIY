--Kyami Kyami
local m=37564525
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,37564765,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),1,true,true)
	Senya.AddSelfFusionProcedure(c,LOCATION_MZONE,Duel.Release)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(cm.descon)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	Senya.NegateEffectWithoutChainingModule(c,cm.discon,cm.DiscardHandCost,nil,m*16,true,nil)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and re:IsActiveType(TYPE_MONSTER) and c:GetEquipGroup():IsExists(cm.cf,1,nil,re:GetHandler())
end
function cm.cf(c,rc)
	if not c:IsAbleToGraveAsCost() then return false end
	if c:IsCode(37564517) then return true end
	return bit.band(c:GetAttribute(),rc:GetAttribute())~=0 or bit.band(c:GetRace(),rc:GetRace())~=0
end
function cm.DiscardHandCost(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=c:GetEquipGroup():FilterSelect(tp,cm.cf,1,1,nil,re:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsFaceup() and bc and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and bc:IsAbleToChangeControler()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
	if c:IsRelateToBattle() and bc:IsRelateToBattle() then
			if Duel.Equip(tp,bc,c,false) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(function(e,c)
					return e:GetOwner()==c
				end)
				bc:RegisterEffect(e1)
			end
	end
end
