--花舞少女·真智
local m=14141004
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c14141006") end,function() require("script/c14141006") end)
cm.named_with_hana=true
function cm.initial_effect(c)
	scorp.hana_common_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m-3,2))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(0x14000)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(function(e,tp,eg)
		return eg:IsExists(cm.filter,1,e:GetHandler(),tp)
	end)
	e1:SetCost(scorp.sethcost)
	e1:SetTarget(scorp.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,scorp.hanaspfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,m)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local cg=eg:Filter(cm.filter,e:GetHandler(),tp)
		local f=Card.RegisterEffect
		Card.RegisterEffect=cm.replace_register_effect(f)
		for code in cm.cpairs(cg) do
			tc:CopyEffect(code,0x1fe1000,1)
		end
		Card.RegisterEffect=f
		Duel.SpecialSummonComplete()
	end
end
function cm.filter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function cm.replace_register_effect(f)
	return function(tc,e,forced)
		local t=e:GetType()
		if bit.band(t,EFFECT_TYPE_IGNITION)~=0 then
			e:SetType(bit.bor(t-EFFECT_TYPE_IGNITION,EFFECT_TYPE_QUICK_O))
			e:SetCode(EVENT_FREE_CHAIN)
			e:SetHintTiming(0,0x1e0)
		end
		f(tc,e,forced)
	end
end
function cm.cpairs(g)
	local f=Group.GetFirst
	return function()
		local tc=f(g)		
		f=Group.GetNext
		return tc and tc:GetOriginalCode()
	end
end